# Terraform Action

Provides a GitHub action for performing Terraform subcommands apply or destroy. For more
details see the README for the respective subcommand actions:

- [`apply`](./apply)
- [`destroy`](./destroy)

## Example

```yaml
---
on:
  pull_request:
    types:
      - opened
      - closed
jobs:
  apply:
    name: Apply
    if: ${{ github.event.action == 'opened' }}
    # These permissions are needed to:
    # - Checkout the repository
    permissions:
      contents: read
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
        with:
          # Avoiding using Terraform 1.10 at this time as it does not work well with `apply --auto-approve`:
          # https://github.com/hashicorp/terraform/issues/36106#issuecomment-2506181760
          terraform_version: "~1.9"
      - name: Deploy Terraform resources
        id: terraform
        uses: beacon-biosignals/terraform-action/apply@v1
        with:
          workspace: ${{ github.event.number }}
          variables: |-
            name: Demo

  destroy:
    name: Destroy
    if: ${{ github.event.action == 'closed' }}
    # These permissions are needed to:
    # - Checkout the repository
    permissions:
      contents: read
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
        with:
          # Avoiding using Terraform 1.10 at this time as it does not work well with `apply --auto-approve`:
          # https://github.com/hashicorp/terraform/issues/36106#issuecomment-2506181760
          terraform_version: "~1.9"
      - name: Destroy Terraform resources
        id: terraform
        uses: beacon-biosignals/terraform-action/destroy@v1
        with:
          workspace: ${{ github.event.number }}
          variables: |-
            name: Demo
```

## Permissions

No [job permissions](https://docs.github.com/en/actions/using-jobs/assigning-permissions-to-jobs) are required to run this action.
