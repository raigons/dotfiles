#!/bin/bash

# Script to add a new work git profile to dotfiles
# Usage: git-add-work-profile.sh [company-name]

set -e

DOTFILES="${HOME}/dotfiles"
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Git Work Profile Setup${NC}\n"

# Get company name
if [ -n "$1" ]; then
  COMPANY_NAME="$1"
else
  read -p "Enter company name (lowercase, e.g., 'acme'): " COMPANY_NAME
fi

# Validate company name
if [[ ! "$COMPANY_NAME" =~ ^[a-z0-9-]+$ ]]; then
  echo -e "${RED}❌ Error: Company name must be lowercase alphanumeric with hyphens only${NC}"
  exit 1
fi

# Get user information
read -p "Enter your full name: " USER_NAME
read -p "Enter your work email: " USER_EMAIL
read -p "Enter work directory path (e.g., ~/Documents/work/${COMPANY_NAME}): " WORK_DIR

# Expand tilde
WORK_DIR="${WORK_DIR/#\~/$HOME}"

# Ensure directory ends with /
[[ "${WORK_DIR}" != */ ]] && WORK_DIR="${WORK_DIR}/"

echo -e "\n${YELLOW}📋 Summary:${NC}"
echo "  Company: ${COMPANY_NAME}"
echo "  Name: ${USER_NAME}"
echo "  Email: ${USER_EMAIL}"
echo "  Directory: ${WORK_DIR}"
echo "  SSH Key: ~/.ssh/id_rsa-${COMPANY_NAME}"
echo "  Config: ~/.gitconfig-${COMPANY_NAME}"

read -p $'\nProceed? (y/n): ' CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo "Cancelled."
  exit 0
fi

# Step 1: Generate SSH key
echo -e "\n${BLUE}1. Generating SSH key...${NC}"
if [ -f ~/.ssh/id_rsa-${COMPANY_NAME} ]; then
  echo -e "${YELLOW}⚠️  SSH key already exists, skipping...${NC}"
else
  ssh-keygen -t rsa -b 4096 -C "${USER_EMAIL}" -f ~/.ssh/id_rsa-${COMPANY_NAME} -N ""
  echo -e "${GREEN}✓ SSH key generated${NC}"
fi

# Step 2: Add SSH key to ssh-agent
echo -e "\n${BLUE}2. Adding SSH key to ssh-agent...${NC}"
eval "$(ssh-agent -s)" > /dev/null 2>&1
ssh-add ~/.ssh/id_rsa-${COMPANY_NAME}
echo -e "${GREEN}✓ SSH key added to agent${NC}"

# Step 3: Copy public key to clipboard
echo -e "\n${BLUE}3. Copying public key to clipboard...${NC}"
if command -v pbcopy &> /dev/null; then
  pbcopy < ~/.ssh/id_rsa-${COMPANY_NAME}.pub
  echo -e "${GREEN}✓ Public key copied to clipboard${NC}"
  echo -e "${YELLOW}📌 Action required: Add this SSH key to your GitHub/GitLab account${NC}"
  echo "   GitHub: https://github.com/settings/ssh/new"
  echo "   GitLab: https://gitlab.com/-/profile/keys"
  read -p $'\nPress Enter after adding the SSH key to GitHub/GitLab...'
else
  echo "Public key:"
  cat ~/.ssh/id_rsa-${COMPANY_NAME}.pub
  read -p $'\nPress Enter after copying and adding the SSH key to GitHub/GitLab...'
fi

# Step 4: Create git config profile
echo -e "\n${BLUE}4. Creating git config profile...${NC}"
cat > ${DOTFILES}/config/git/.gitconfig-${COMPANY_NAME} << EOF
[user]
  name = ${USER_NAME}
  email = ${USER_EMAIL}

[core]
  sshCommand = "ssh -i ~/.ssh/id_rsa-${COMPANY_NAME}"
EOF
echo -e "${GREEN}✓ Created ${DOTFILES}/config/git/.gitconfig-${COMPANY_NAME}${NC}"

# Step 5: Update main .gitconfig
echo -e "\n${BLUE}5. Updating main .gitconfig...${NC}"
if grep -q "gitconfig-${COMPANY_NAME}" ${DOTFILES}/config/git/.gitconfig; then
  echo -e "${YELLOW}⚠️  Entry already exists in .gitconfig, skipping...${NC}"
else
  cat >> ${DOTFILES}/config/git/.gitconfig << EOF

[includeIf "gitdir:${WORK_DIR}"]
	path = "~/.gitconfig-${COMPANY_NAME}"
EOF
  echo -e "${GREEN}✓ Updated ${DOTFILES}/config/git/.gitconfig${NC}"
fi

# Step 6: Create symlink
echo -e "\n${BLUE}6. Creating symlink...${NC}"
ln -fsv ${DOTFILES}/config/git/.gitconfig-${COMPANY_NAME} ~/.gitconfig-${COMPANY_NAME}
echo -e "${GREEN}✓ Symlink created${NC}"

# Step 7: Update install.sh
echo -e "\n${BLUE}7. Updating install.sh...${NC}"
if grep -q "gitconfig-${COMPANY_NAME}" ${DOTFILES}/install.sh; then
  echo -e "${YELLOW}⚠️  install.sh already contains ${COMPANY_NAME}, skipping...${NC}"
else
  # Add to backup section
  sed -i.bak "/\[ -f ~\\/\\.gitconfig-anonymous \]/a\\
  [ -f ~/.gitconfig-${COMPANY_NAME} ] && cp ~/.gitconfig-${COMPANY_NAME} \"\${BACKUP_DIR}/.gitconfig-${COMPANY_NAME}\"
" ${DOTFILES}/install.sh

  # Add to symlink section
  sed -i.bak "/ln -fsv.*\\.gitconfig-anonymous/a\\
ln -fsv \${DOTFILES}/config/git/.gitconfig-${COMPANY_NAME} ~/.
" ${DOTFILES}/install.sh

  rm ${DOTFILES}/install.sh.bak
  echo -e "${GREEN}✓ Updated ${DOTFILES}/install.sh${NC}"
fi

# Step 8: Create work directory
echo -e "\n${BLUE}8. Creating work directory...${NC}"
if [ -d "${WORK_DIR}" ]; then
  echo -e "${YELLOW}⚠️  Directory already exists: ${WORK_DIR}${NC}"
else
  mkdir -p "${WORK_DIR}"
  echo -e "${GREEN}✓ Created directory: ${WORK_DIR}${NC}"
fi

# Step 9: Test configuration
echo -e "\n${BLUE}9. Testing configuration...${NC}"
cd "${WORK_DIR}"
if [ -d .git ]; then
  TEST_EMAIL=$(git config user.email)
  TEST_NAME=$(git config user.name)
else
  # Create temporary git repo to test
  mkdir -p .git-test-temp
  cd .git-test-temp
  git init > /dev/null 2>&1
  TEST_EMAIL=$(git config user.email)
  TEST_NAME=$(git config user.name)
  cd ..
  rm -rf .git-test-temp
fi

if [ "$TEST_EMAIL" = "$USER_EMAIL" ] && [ "$TEST_NAME" = "$USER_NAME" ]; then
  echo -e "${GREEN}✓ Configuration verified!${NC}"
  echo "  Name: ${TEST_NAME}"
  echo "  Email: ${TEST_EMAIL}"
else
  echo -e "${RED}⚠️  Configuration might not be working correctly${NC}"
  echo "  Expected: ${USER_NAME} <${USER_EMAIL}>"
  echo "  Got: ${TEST_NAME} <${TEST_EMAIL}>"
fi

# Step 10: Test SSH connection (optional)
echo -e "\n${BLUE}10. Testing SSH connection...${NC}"
read -p "Test SSH connection to GitHub? (y/n): " TEST_SSH
if [[ "$TEST_SSH" =~ ^[Yy]$ ]]; then
  if ssh -T git@github.com -i ~/.ssh/id_rsa-${COMPANY_NAME} 2>&1 | grep -q "successfully authenticated"; then
    echo -e "${GREEN}✓ SSH connection successful!${NC}"
  else
    echo -e "${YELLOW}⚠️  SSH test failed. You may need to verify the key was added to GitHub/GitLab${NC}"
  fi
fi

# Summary
echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Setup complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "\n${YELLOW}📝 Next steps:${NC}"
echo "  1. Commit the changes to your dotfiles:"
echo "     cd ${DOTFILES}"
echo "     git add config/git/.gitconfig config/git/.gitconfig-${COMPANY_NAME} install.sh"
echo "     git commit -m 'feat: add ${COMPANY_NAME} work profile'"
echo ""
echo "  2. All repositories in ${WORK_DIR} will now use:"
echo "     - Name: ${USER_NAME}"
echo "     - Email: ${USER_EMAIL}"
echo "     - SSH Key: ~/.ssh/id_rsa-${COMPANY_NAME}"
echo ""
echo -e "${BLUE}💡 Tip: Test it by creating a repo in ${WORK_DIR}${NC}"
