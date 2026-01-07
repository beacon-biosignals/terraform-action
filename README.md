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
      - uses: actions/checkout@v5
      - uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: "~1.13"
          # Graceful termination on cancellation is not compatible with the wrapper
          terraform_wrapper: false
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
      - uses: actions/checkout@v5
      - uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: "~1.13"
          # Graceful termination on cancellation is not compatible with the wrapper
          terraform_wrapper: false
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

## Cancellation and `hashicorp/setup-terraform`

These actions attempt to forward signals used by Github Actions to cancel running jobs to Terraform in order to allow Terraform to exit gracefully.  If Terraform does _not_ exit gracefully, it may leave lockfiles or incorrect state around.

These actions _do not_ install Terraform for you; if you are installing Terraform using the `setup-terraform` action, you _must_ set `terraform_wrapper: false` as in the examples above.  Otherwise, the `terraform` executable is a Node wrapper which is incapable of forwarding any signals to the actual `terraform` binary.  See [this discussion](https://github.com/orgs/community/discussions/26311#discussioncomment-7571648) for more details.
