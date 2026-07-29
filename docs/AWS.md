# AWS CLI Guide

Installation and configuration for the AWS CLI on a machine set up from these dotfiles.

## Installation

The AWS CLI is part of the `Brewfile`, so a normal bootstrap installs it:

```bash
cd ~/dotfiles
./install.sh
```

To install it on its own:

```bash
brew install awscli
```

Verify:

```bash
aws --version
# aws-cli/2.x.x Python/3.x.x Darwin/x.x.x source/arm64
```

Homebrew installs AWS CLI **v2**. Do not also install `pip install awscli` — that is v1
and the two fight over the `aws` name on `PATH`.

### Session Manager plugin

`session-manager-plugin` is already a cask in the `Brewfile`. It is required for
`aws ssm start-session` (shell into an EC2 instance without SSH):

```bash
brew install --cask session-manager-plugin
session-manager-plugin --version
```

### Shell completion

`.zshrc` adds Homebrew's completion directory to `fpath` before `compinit`, which picks
up the `_aws` function shipped by the `awscli` formula:

```zsh
[ -d /opt/homebrew/share/zsh/site-functions ] && fpath+=/opt/homebrew/share/zsh/site-functions
autoload -U compinit && compinit
```

After a fresh install, reload the shell (`source ~/.zshrc`) and check that `aws s3 <TAB>`
completes. If completions look stale, clear the cache: `rm -f ~/.zcompdump*` and reload.

## Configuration

Nothing in this repo carries AWS credentials — `~/.aws/` is machine-local and must never
be committed. Set it up per machine with one of the two flows below.

### IAM Identity Center (SSO) — preferred

```bash
aws configure sso
```

You are asked for:

| Prompt | Value |
| --- | --- |
| SSO session name | a label, e.g. `work` |
| SSO start URL | `https://<your-org>.awsapps.com/start` |
| SSO region | the region the Identity Center instance lives in, e.g. `us-east-1` |
| SSO registration scopes | accept the default `sso:account:access` |
| CLI default region | e.g. `us-east-1` |
| CLI default output | `json` |
| CLI profile name | e.g. `work` |

The browser opens for approval, then the profile lands in `~/.aws/config`. Sign in again
whenever the session expires:

```bash
aws sso login --profile work
```

### Static access keys

Only for accounts without Identity Center:

```bash
aws configure --profile personal
```

This writes the key pair to `~/.aws/credentials` and the region/output to `~/.aws/config`.
Rotate these keys regularly and prefer short-lived SSO credentials where you can.

## Profiles

Select a profile per command or per shell:

```bash
aws s3 ls --profile work           # one command
export AWS_PROFILE=work            # rest of the shell session
```

`~/.aws/config` after setting up an SSO profile and a role-assuming profile:

```ini
[sso-session work]
sso_start_url = https://your-org.awsapps.com/start
sso_region = us-east-1
sso_registration_scopes = sso:account:access

[profile work]
sso_session = work
sso_account_id = 111122223333
sso_role_name = AdministratorAccess
region = us-east-1
output = json

[profile work-prod]
source_profile = work
role_arn = arn:aws:iam::444455556666:role/DeployRole
region = us-east-1
```

Confirm which identity you are actually using before anything destructive:

```bash
aws sts get-caller-identity
aws configure list-profiles
```

## Common commands

```bash
aws s3 ls                                          # list buckets
aws s3 sync ./build s3://my-bucket --delete        # deploy static files
aws ec2 describe-instances --output table          # instances in the default region
aws ssm start-session --target i-0123456789abcdef  # shell into an instance
aws logs tail /aws/lambda/my-fn --follow           # stream CloudWatch logs
aws ecr get-login-password | docker login --username AWS --password-stdin \
  111122223333.dkr.ecr.us-east-1.amazonaws.com     # docker login to ECR
```

Handy environment variables: `AWS_PROFILE`, `AWS_REGION`, `AWS_PAGER=""` (disables the
pager that AWS CLI v2 opens for every result).

## Troubleshooting

**`command not found: aws`** — Homebrew's `bin` is not on `PATH`. Check
`echo $PATH | tr ':' '\n' | grep homebrew`; `.zshrc` should be exporting
`/opt/homebrew/bin`.

**`The SSO session associated with this profile has expired`** — run
`aws sso login --profile <name>`.

**`Unable to locate credentials`** — no profile is selected. Set `AWS_PROFILE` or pass
`--profile`, and verify with `aws configure list`.

**Wrong account** — an `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY` exported in the shell
overrides the profile. Check with `env | grep AWS` and `unset` the strays.

**`SessionManagerPlugin is not found`** — install the cask:
`brew install --cask session-manager-plugin`.
