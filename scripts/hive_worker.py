#!/usr/bin/env python3
import os
import sys
import argparse
import subprocess
import re
from pathlib import Path
from dotenv import load_dotenv

try:
    from google import genai
    from google.genai import types
except ImportError:
    print("❌ Error: Required dependencies not found.")
    print("Please run: pip install google-genai python-dotenv")
    sys.exit(1)

# Load environment variables (for GEMINI_API_KEY)
load_dotenv()

class HiveWorker:
    def __init__(self, plan_path, task_id, model_name="gemini-2.5-flash", debug=False):
        self.plan_path = Path(plan_path)
        self.task_id = task_id
        self.model_name = model_name
        self.debug = debug
        self.api_key = os.getenv("GEMINI_API_KEY")
        self.root_dir = Path(__file__).parent.parent
        
        if not self.api_key:
            print("❌ Error: GEMINI_API_KEY not found in environment or .env file.")
            sys.exit(1)
            
        self.client = genai.Client(api_key=self.api_key)

    def get_task_details(self):
        """Parses the PLAN_*.md file to find the task by ID."""
        if not self.plan_path.exists():
            print(f"❌ Error: Plan file {self.plan_path} not found.")
            sys.exit(1)
            
        content = self.plan_path.read_text()
        
        # Search for ## Task <task_id>: <name> OR ### Task <task_id> (case-insensitive, tolerant of spaces)
        pattern = rf"#{{2,4}}\s*Task\s+{self.task_id}[:\-]?\s*(.*?)\n(.*?)(?=\n#{{2,4}}\s*Task|\Z)"
        match = re.search(pattern, content, re.DOTALL | re.IGNORECASE)
        
        if not match:
            print(f"❌ Error: Task {self.task_id} not found in {self.plan_path.name}")
            sys.exit(1)
            
        task_name = match.group(1).strip()
        task_body = match.group(2).strip()
        
        return {
            "name": task_name,
            "goal": self._extract_field(task_body, "Goal"),
            "files": self._extract_list(task_body, "Files to edit"),
            "notes": self._extract_field(task_body, "Implementation notes"),
            "verify": self._extract_field(task_body, "Verification commands")
        }

    def _extract_field(self, text, field_name):
        # Robust regex: handles `- **Goal:**`, `* **Goal**`, etc.
        pattern = rf"[-*]\s*\*\*{field_name}[:\*]*\s*(.*?)(?=\n[-*]\s*\*\*|\Z)"
        match = re.search(pattern, text, re.DOTALL | re.IGNORECASE)
        return match.group(1).strip() if match else ""

    def _extract_list(self, text, field_name):
        pattern = rf"[-*]\s*\*\*{field_name}[:\*]*\s*(.*?)(?=\n[-*]\s*\*\*|\Z)"
        match = re.search(pattern, text, re.DOTALL | re.IGNORECASE)
        if not match: return []
        items = match.group(1).strip().split('\n')
        # Allow leading spaces before the hyphen
        return [re.sub(r'^\s*[-*]\s*|`', '', item).strip() for item in items if item.strip()]

    def execute(self):
        details = self.get_task_details()
        print(f"🐝 Mission: {self.task_id} - {details['name']}")
        
        # 1. Determine Git Context
        repo_dir = self.root_dir
        if details['files']:
            target_file = self.root_dir / details['files'][0]
            print(f"🔍 Searching for git repo relative to {target_file}")
            current = target_file.parent
            while current != current.parent:
                if (current / ".git").exists():
                    repo_dir = current
                    print(f"📂 Found git repo at {repo_dir}")
                    break
                current = current.parent

        # 2. Create Git Branch
        branch_name = f"hive/{self.task_id}-{details['name'].lower().replace(' ', '-')}"
        is_git = (repo_dir / ".git").exists()
        if is_git:
            # Safety check: ensure no uncommitted changes
            status = subprocess.run(["git", "status", "--porcelain"], cwd=repo_dir, capture_output=True, text=True)
            if status.stdout.strip():
                print(f"⚠️ Warning: Uncommitted changes detected in {repo_dir}. Consider stashing them.")
                
            print(f"🌱 Creating branch {branch_name} in {repo_dir}")
            try:
                subprocess.run(["git", "checkout", "-b", branch_name], cwd=repo_dir, check=True, capture_output=True)
            except subprocess.CalledProcessError as e:
                if "already exists" in e.stderr.decode():
                    print(f"🔄 Branch {branch_name} already exists. Switching to it.")
                    subprocess.run(["git", "checkout", branch_name], cwd=repo_dir, check=True, capture_output=True)
                else:
                    print(f"❌ Git error: {e.stderr.decode()}")
        else:
            print("⚠️ No git repository found. Proceeding with direct edits.")

        # 3. Read Target Files
        file_contexts = []
        for file_path in details['files']:
            p = (self.root_dir / file_path).resolve()
            if p.exists():
                print(f"📖 Reading {file_path}")
                file_contexts.append(f"--- FILE: {file_path} ---\n{p.read_text()}")
            else:
                print(f"🆕 {file_path} is a new file")
                file_contexts.append(f"--- FILE: {file_path} (NEW) ---\n[Empty]")

        # 4. Construct Prompt
        system_rules = (self.root_dir / "GEMINI.md").read_text()
        prompt = f"""
You are a stateless Hive Worker agent. Your mission is to execute an atomic task.

### MISSION DATA
- TASK: {self.task_id} - {details['name']}
- GOAL: {details['goal']}
- NOTES: {details['notes']}

### TARGET FILES
{"".join(file_contexts)}

### INSTRUCTIONS
1. Apply the changes to the target files based on the GOAL and NOTES.
2. You MUST use the exact filenames provided in the TARGET FILES section.
3. Output the FULL, COMPLETE content of each modified file. Do not use placeholders or omit unchanged code.
4. Format your response as a series of code blocks, each preceded by the filename line like so:

FILE: path/to/file
```python
[full content]
```

FAILURE TO PROVIDE THE FULL FILE CONTENT OR USING INCORRECT FILENAMES WILL RESULT IN MISSION FAILURE.
"""

        # 5. Call Gemini
        print(f"🤖 Requesting edits from Gemini ({self.model_name})...")
        if self.debug:
            print(f"\n[DEBUG] Prompt:\n{prompt}\n")
            
        response = self.client.models.generate_content(
            model=self.model_name,
            contents=prompt,
            config=types.GenerateContentConfig(
                system_instruction=system_rules,
                temperature=0.1,  # Low temperature for deterministic formatting
            )
        )
        
        if self.debug:
            print(f"\n[DEBUG] Raw Response:\n{response.text}\n")
            
        # 6. Apply Changes
        self._apply_edits(response.text, details['files'])
        
        # 7. Verify
        if details['verify']:
            print(f"🔍 Running verification: {details['verify']}")
            res = subprocess.run(details['verify'], shell=True, capture_output=True, text=True, cwd=self.root_dir)
            if res.returncode != 0:
                print(f"⚠️ Verification Failed!\n{res.stderr}")
            else:
                print("✅ Verification Passed.")

        print(f"🏁 Task {self.task_id} completed.")

    def _apply_edits(self, text, allowed_files):
        # Relaxed regex: handles bold FILE, optional spaces, and arbitrary backtick blocks
        pattern = r"\*?\*?FILE:\*?\*?\s*(.*?)\n\s*```(?:\w+)?\n(.*?)\n\s*```"
        matches = re.finditer(pattern, text, re.DOTALL | re.IGNORECASE)
        
        applied_any = False
        for match in matches:
            file_path = match.group(1).strip()
            content = match.group(2)
            
            # Security/Hallucination check: only allow edits to files in the task
            if file_path not in allowed_files:
                print(f"❌ Gemini tried to edit unauthorized/hallucinated path: {file_path}")
                continue

            p = self.root_dir / file_path
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text(content)
            print(f"💾 Applied changes to {file_path}")
            applied_any = True
        
        if not applied_any:
            print("⚠️ No valid file edits were found in Gemini's response.")
            print("\n--- RAW LLM RESPONSE ---")
            print(text)
            print("------------------------\n")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Hive Worker - Stateless Task Executor")
    parser.add_argument("--plan", required=True, help="Path to the PLAN_*.md file")
    parser.add_argument("--task", required=True, help="Task ID (e.g. T1)")
    parser.add_argument("--model", default="gemini-2.5-flash", help="Gemini model to use")
    parser.add_argument("--debug", action="store_true", help="Print raw prompt and raw LLM response")
    
    args = parser.parse_args()
    
    worker = HiveWorker(args.plan, args.task, args.model, args.debug)
    worker.execute()
