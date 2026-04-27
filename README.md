# Finance Manager Ecosystem

This is the default repository for the Hive financial manager ecosystem. It
tracks the component repositories that make up the system through Git
submodules.

## Channel

Project updates and coordination are shared in Slack channel
`#all-hive-financial-manager`.

## Submodules

| Path | Repository |
| --- | --- |
| `design_docs` | `git@github.com:AzazelAzure/finance-manager-design-docs.git` |
| `finance_manager_api` | `git@github.com:AzazelAzure/finance-manager-api.git` |
| `finance_manager_cli` | `git@github.com:AzazelAzure/finance-manager-cli.git` |
| `finance_manager_reflex` | `git@github.com:AzazelAzure/finance-manger-reflex-frontend.git` |
| `finance_manager_android` | `git@github.com:AzazelAzure/finance-manager-andriod.git` |

To initialize the component repositories after cloning:

```bash
git submodule update --init --recursive
```
