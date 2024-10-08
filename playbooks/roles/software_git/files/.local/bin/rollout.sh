#
unset GITHUB_TOKEN

# Extract type and description from commit message
type=$1; shift
description="$@"
commit_message="$type: $description"

# Check if a commit message was provided
if [ -z "$1" ] || [ -z "$description" ]; then
    echo "Usage: rollout <type> <...description>"
    exit 1
fi

# Create branch name following Conventional Commit syntax
branch_name="${type}/$(echo "$description" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"

echo "Creating and checking out branch: $branch_name"
git checkout -b "$branch_name" || exit 1

# Add all changes
git add . || exit 1

echo "Committing with message: \"$commit_message\""
git commit -m "$commit_message" || exit 1

echo "Pushing branch to origin..."
git push --set-upstream origin HEAD || exit 1

echo "Creating a Pull Request..."
gh pr create --fill

echo "Rollout complete."
