# Git Configuration Guide

This dotfiles setup uses a multi-profile git configuration system that automatically switches your git identity (name, email, SSH key) based on which project directory you're working in.

## How It Works

The main `.gitconfig` uses Git's `includeIf` directive to conditionally load different configurations based on your current directory:

```gitconfig
[includeIf "gitdir:~/Documents/erlang-solutions/elc/"]
    path = "~/.gitconfig-work"

[includeIf "gitdir:~/Documents/personal/"]
    path = "~/.gitconfig-personal"

[includeIf "gitdir:~/Documents/assessments/"]
    path = "~/.gitconfig-anonymous"
```

## Current Profiles

### Work Profile (`.gitconfig-work`)
- **Email**: rgoncalv@estee.com
- **SSH Key**: `~/.ssh/id_rsa-elc`
- **Used for**: Estée Lauder Companies projects
- **Directories**: `~/Documents/erlang-solutions/elc/`

### Personal Profile (`.gitconfig-personal`)
- **Email**: raigons@gmail.com
- **SSH Key**: `~/.ssh/id_rsa-personal`
- **Used for**: Personal projects, dotfiles, side projects
- **Directories**:
  - `~/Documents/personal/`
  - `~/dotfiles/`
  - Various client projects (PepsiCo, Razoyo, Cortex, etc.)

### Anonymous Profile (`.gitconfig-anonymous`)
- **Name**: Anonymous
- **Email**: (empty)
- **Used for**: Code assessments and interview challenges
- **Directories**: `~/Documents/assessments/`

## Adding a New Work Configuration

### Quick Method: Use the Automated Script

The easiest way to add a new work profile is to use the included script:

```bash
# Run the interactive script
git-add-work

# Or with company name as argument
git-add-work acme
```

The script will:
1. ✅ Generate SSH key for the new company
2. ✅ Add SSH key to ssh-agent
3. ✅ Copy public key to clipboard
4. ✅ Create git config profile
5. ✅ Update main .gitconfig with conditional include
6. ✅ Create symlink
7. ✅ Update install.sh
8. ✅ Create work directory
9. ✅ Test configuration
10. ✅ Test SSH connection (optional)

The script is interactive and will guide you through each step!

### Manual Method

If you prefer to do it manually, follow these steps:

### 1. Generate SSH Key

```bash
# Generate a new SSH key for the new company
ssh-keygen -t rsa -b 4096 -C "your.email@newcompany.com" -f ~/.ssh/id_rsa-newcompany

# Start the ssh-agent
eval "$(ssh-agent -s)"

# Add the SSH key to ssh-agent
ssh-add ~/.ssh/id_rsa-newcompany

# Copy the public key to clipboard
pbcopy < ~/.ssh/id_rsa-newcompany.pub
```

### 2. Add SSH Key to GitHub/GitLab

1. Go to GitHub/GitLab settings
2. Navigate to SSH Keys
3. Paste your public key
4. Give it a descriptive name (e.g., "MacBook - NewCompany")

### 3. Configure SSH Config (Optional but Recommended)

Edit `~/.ssh/config` to add an alias for the new company:

```bash
# NewCompany GitHub
Host github.com-newcompany
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_rsa-newcompany
  IdentitiesOnly yes
```

### 4. Create Git Configuration Profile

Create a new git config file in the dotfiles project:

```bash
cd ~/dotfiles/config/git
```

Create `.gitconfig-newcompany`:

```gitconfig
[user]
  name = Your Name
  email = your.email@newcompany.com

[core]
  sshCommand = "ssh -i ~/.ssh/id_rsa-newcompany"

# If using SSH config alias (optional)
[url "git@github.com-newcompany:organization-name"]
  insteadOf = https://github.com/organization-name
```

### 5. Update Main Git Configuration

Edit `~/dotfiles/config/git/.gitconfig` to add the new conditional include:

```gitconfig
[includeIf "gitdir:~/Documents/newcompany/"]
    path = "~/.gitconfig-newcompany"
```

**Note**: The path must end with a `/` to match all subdirectories.

### 6. Update install.sh

Edit `~/dotfiles/install.sh` to include the new config file:

**In the backup section**, add:
```bash
[ -f ~/.gitconfig-newcompany ] && cp ~/.gitconfig-newcompany "${BACKUP_DIR}/.gitconfig-newcompany"
```

**In the symlink section**, add:
```bash
ln -fsv ${DOTFILES}/config/git/.gitconfig-newcompany ~/.
```

### 7. Create Symlink

If you haven't run the full install script, create the symlink manually:

```bash
ln -fsv ~/dotfiles/config/git/.gitconfig-newcompany ~/.gitconfig-newcompany
```

### 8. Verify Configuration

Test that the configuration works correctly:

```bash
# Create a test directory
mkdir -p ~/Documents/newcompany/test-repo
cd ~/Documents/newcompany/test-repo

# Initialize a git repo
git init

# Check which identity git will use
git config user.name
git config user.email
git config core.sshCommand
```

You should see your new company's name, email, and SSH command.

### 9. Test SSH Connection

Verify SSH key works with GitHub/GitLab:

```bash
# For GitHub
ssh -T git@github.com -i ~/.ssh/id_rsa-newcompany

# For GitLab
ssh -T git@gitlab.com -i ~/.ssh/id_rsa-newcompany
```

You should see a success message like:
```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

## Bare Clone & Init with Worktrees

Two custom git subcommands automate the bare repo + worktree pattern, which is ideal for working on multiple branches simultaneously without stashing or switching.

### `git bare-clone` — Clone a Remote Repository

```bash
# Clone with auto-detected directory name
git bare-clone git@github.com:user/repo.git

# Clone into a specific directory
git bare-clone git@github.com:user/repo.git my-project
```

### `git bare-init` — Initialize a Local Directory

```bash
# In an empty directory
mkdir my-project && cd my-project
git bare-init

# In a directory with existing files (moves them into main/)
cd existing-project
git bare-init
```

### What They Create

```
project/
├── .bare/       ← bare git database (shared by all worktrees)
├── .git         ← pointer file (gitdir: ./.bare)
└── main/        ← worktree on default branch
```

### Working with Worktrees

```bash
cd project

# Add a new worktree for a feature branch
git worktree add feature-x -b feature-x

# Add a worktree for an existing remote branch
git worktree add fix-bug origin/fix-bug

# List all worktrees
git worktree list

# Remove a worktree when done
git worktree remove feature-x
```

### Why Bare + Worktrees?

- **No stashing needed** — each branch lives in its own directory
- **Parallel work** — run tests on one branch while coding on another
- **Clean separation** — no risk of uncommitted changes leaking between branches
- **Shared object store** — all worktrees share the same `.bare` database, saving disk space

## Quick Reference

### Check Current Git Identity

```bash
git config user.name
git config user.email
git config core.sshCommand
```

### List All Git Configs

```bash
git config --list --show-origin
```

### Test Which Config File is Active

```bash
cd /path/to/project
git config --show-origin user.email
```

## Troubleshooting

### Wrong Identity Being Used

1. Check the directory path in `.gitconfig` matches exactly
2. Ensure the path ends with `/`
3. Verify the symlink exists: `ls -la ~/.gitconfig-*`
4. Check for typos in the `includeIf` directive

### SSH Key Not Working

1. Verify the key is added to ssh-agent: `ssh-add -l`
2. Re-add the key: `ssh-add ~/.ssh/id_rsa-newcompany`
3. Check permissions: `chmod 600 ~/.ssh/id_rsa-newcompany`
4. Test SSH connection directly: `ssh -T git@github.com -i ~/.ssh/id_rsa-newcompany`

### Can't Push to Repository

1. Verify you've added the SSH public key to GitHub/GitLab
2. Check the URL format: `git remote -v`
3. If using HTTPS, convert to SSH: `git remote set-url origin git@github.com:username/repo.git`

## Example: Adding a Second Work Profile

Let's say you start working for "Acme Corp":

```bash
# 1. Generate SSH key
ssh-keygen -t rsa -b 4096 -C "john@acme.com" -f ~/.ssh/id_rsa-acme
ssh-add ~/.ssh/id_rsa-acme

# 2. Add to GitHub (copy & paste the public key)
pbcopy < ~/.ssh/id_rsa-acme.pub

# 3. Create config file
cat > ~/dotfiles/config/git/.gitconfig-acme << 'EOF'
[user]
  name = John Doe
  email = john@acme.com

[core]
  sshCommand = "ssh -i ~/.ssh/id_rsa-acme"
EOF

# 4. Add to main .gitconfig
echo '[includeIf "gitdir:~/Documents/acme/"]' >> ~/dotfiles/config/git/.gitconfig
echo '    path = "~/.gitconfig-acme"' >> ~/dotfiles/config/git/.gitconfig

# 5. Create symlink
ln -fsv ~/dotfiles/config/git/.gitconfig-acme ~/.gitconfig-acme

# 6. Test
mkdir -p ~/Documents/acme/test && cd ~/Documents/acme/test
git init
git config user.email  # Should show: john@acme.com
```

## Best Practices

1. **Keep SSH keys separate** - Never reuse SSH keys across different companies
2. **Use descriptive names** - Name files clearly: `.gitconfig-companyname`
3. **Document the structure** - Keep this guide updated with new profiles
4. **Test before committing** - Always verify identity before making commits
5. **Backup your keys** - Store SSH keys securely (use a password manager or encrypted backup)
6. **Rotate keys periodically** - Update SSH keys every 1-2 years for security

## Security Notes

- Never commit private SSH keys to git repositories
- The `.gitconfig-*` files in this dotfiles repo should NOT contain sensitive data
- SSH keys should remain in `~/.ssh/` directory only
- Consider using GPG signing for work commits (can be added to profile configs)
