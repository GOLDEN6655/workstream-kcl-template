#!/bin/bash

# Variables
REPO="GOLDEN6655/workstream-kcl-template"  # Replace with your GitHub repository (e.g., "username/repo")
RELEASE_VERSION="v1.0.0"  # Define the release version (e.g., based on user input or auto-increment)
RELEASE_TITLE="Release $RELEASE_VERSION"
RELEASE_NOTES="Changelog for release $RELEASE_VERSION"
CHANGELOG_FILE="CHANGELOG.md"  # Optional: Path to a changelog file (if you have one)
TAG_NAME="$RELEASE_VERSION"  # Tag name for the release

# Check if 'gh' CLI is installed
if ! command -v gh &> /dev/null
then
    echo "'gh' GitHub CLI not found. Please install it from https://cli.github.com/ and authenticate using 'gh auth login'."
    exit 1
fi

# Step 1: Check if the version tag already exists
echo "Checking if tag $TAG_NAME already exists..."
TAG_EXISTS=$(git ls-remote --tags origin | grep -w "refs/tags/$TAG_NAME" | wc -l)

if [ "$TAG_EXISTS" -eq "1" ]; then
  echo "Tag $TAG_NAME already exists. Please choose a different version."
  exit 1
fi

# Step 2: Create a new tag and push it to the repository
echo "Creating and pushing tag $TAG_NAME..."
git tag $TAG_NAME
git push origin $TAG_NAME

# Step 3: Check if a changelog file exists (optional)
if [[ -f "$CHANGELOG_FILE" ]]; then
    echo "Using changelog from $CHANGELOG_FILE..."
    RELEASE_NOTES=$(cat $CHANGELOG_FILE)
else
    echo "Changelog file not found. Using default release notes."
fi

# Step 4: Create the GitHub release using the 'gh' CLI
echo "Creating a new GitHub release..."
gh release create "$TAG_NAME" \
  --repo "$REPO" \
  --title "$RELEASE_TITLE" \
  --notes "$RELEASE_NOTES" \
  --target "main"  # Specify the target branch (e.g., main, master)

echo "GitHub release $RELEASE_VERSION created successfully!"
