# Terraform Action: Destroy

Perform a Terraform [destroy](https://developer.hashicorp.com/terraform/cli/commands/destroy) (`apply -destroy`) using the provided inputs.

## Inputs

The `terraform-action/destroy` action supports the following inputs:

| Name                 | Description | Required | Example |
|:---------------------|:------------|:---------|:--------|
| `dir`                | The working directory containing the Terraform project. Defaults to `"."` | No | `".terraform"` |
| `workspace`          | Name of the Terraform workspace to use during the operation. | No | `${{ github.event.number }}` |
| `lock`               | Boolean which specifies if a state lock is to be held during the operation. May be set to `false` if utilizing GitHub action concurrency groups to restrict access. Defaults to `"true"` | No | `"true"` |
| `variables`          | YAML or JSON object containing key/value pairs specifying [input values](https://developer.hashicorp.com/terraform/language/values/variables). Any variables specified here must be declared by the Terraform project or otherwise an error will be thrown. | No | <pre><code class="language-yaml">image_id: ...&#10;availability_zone_names:&#10;  - us-east-1a&#10;  - us-east-1b</code></pre> |
| `optional-variables` | YAML or JSON object containing key/value pairs of input values which will be ignored if the Terraform project doesn't declare them. Typically, users should prefer using `variables` instead. | No |<pre><code class="language-yaml">az_names:&#10;  - us-east-1a&#10;  - us-east-1b</code></pre> |
| `token`              | The GitHub PAT token to use for accessing remote Terraform modules stored on GitHub. Defaults to `${{ github.token }}` | No | |

## Outputs

The `terraform-action/destroy` action does not provide any outputs.

## Permissions

No [job permissions](https://docs.github.com/en/actions/using-jobs/assigning-permissions-to-jobs) are required to run this action. However, destroying some Terraform resources, such as AWS resources, may require additional access.
