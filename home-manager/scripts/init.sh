# Nix setup
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# Run the env.sh script (if it exists). That script is meant to contain secrets, tokens, and
# other things you don't want to put in your Nix config. This is quite "impure" but a
# reasonable workaround.
if [ -e ~/.env.sh ]; then
  . ~/.env.sh
fi

# Suppress direnv log output (which is super verbose and not that useful)
export DIRENV_LOG_FORMAT=

eval "$(ssh-agent -s)"

eval "$(go env)"

# Specific to FlakeHub dev
export ENVRC_USE_FLAKE="1"

### GPG Sign Key ###
export GPG_TTY=$(tty)

### These functions are shortcuts for Git commits using Conventional Commits (https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13)
function gcmfeat() {
  ## Commits, that adds a new feature
  git commit -S -m "feat: $1"
}
function gcmfix() {
  ## Commits, that fixes a bug
  git commit -S -m "fix: $1"
}
function gcmrefactor() {
  ## Commits, that rewrite/restructure your code, however does not change any behaviour
  git commit -S -m "refactor: $1"
}
function gcmperf() {
  ## Commits are special refactor commits, that improves performance
  git commit -S -m "perf: $1"
}
function gcmstyle() {
  ## Commits, that do not affect the meaning (white-space, formatting, missing semi-colons, etc)
  git commit -S -m "style: $1"
}
function gcmtest() {
  ## Commits, that add missing tests or correcting existing tests
  git commit -S -m "test: $1"
}
function gcmdocs() {
  ## Commits, that affect documentation only
  git commit -S -m "docs: $1"
}
function gcmbuild() {
  ## Commits, that affect build components like build tool, ci pipeline, dependencies, project version, ...
  git commit -S -m "build: $1"
}
function gcmops() {
  ## Commits, that affect operational components like infrastructure, deployment, backup, recovery, ...
  git commit -S -m "ops: $1"
}
function gcmchore() {
  ## Miscellaneous commits e.g. modifying .gitignore
  git commit -S -m "chore: $1"
}

### JWT Token Decoder Function ###
jwtd() {
    if [[ -x $(command -v jq) ]]; then
         jq -R 'split(".") | .[0],.[1] | @base64d | fromjson' <<< "${1}"
         echo "Signature: $(echo "${1}" | awk -F'.' '{print $3}')"
    fi
}

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/romelbenavides/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# Create a new branch off of master
# Usage: nb CP-1234
nb() {
  git stash
  git fetch origin
  git checkout master
  git reset --hard origin/master
  git checkout -b $1
}

# Interactively rebase a branch on top of a desired branch
# Usage: grebase origin/master | grebase | grebase origin/EPIC-155-milestone-1
grebase() {
  source_branch=$(git symbolic-ref --short -q HEAD)
  base_branch=${1:-origin\/master}

  echo "\e[34mRebasing \e[31m$source_branch\e[34m on top of \e[31m$base_branch\e[0m"
  git fetch origin
  git rebase -i $base_branch
}

# Merge current branch into a remote branch without a PR (useful for quick merge into dev, please always PR into release)
# Usage: gmo env/qa
gmo() {
  source_branch=$(git symbolic-ref --short -q HEAD)
  destination_branch=$1

  echo "\e[34mMerging \e[31m$source_branch\e[34m in & up to origin/\e[31m$destination_branch\e[0m"

  git fetch origin
  git push origin $source_branch
  git checkout $destination_branch
  git pull --rebase
  git merge $source_branch --no-edit
  git push origin $destination_branch
  git checkout $source_branch
}

# Delete all local branches that dont have 'dev', 'qa', 'release', or 'master' in the name
# Usage: gbclean
gbclean() {
  git branch | grep -v "master" | grep -v "env/.*" | xargs git branch -D
}

# Force push the current branch up to origin
# Usage: gforce
gforce() {
  git push --force origin $(git symbolic-ref --short -q HEAD)
}

# Get a random, securely generated token of a given length, preferable 32 or 64 bytes
# Will also wipe your terminal history
# Usage: fvtoken 64
fvtoken() {
  openssl rand -hex $1
  history -c
}