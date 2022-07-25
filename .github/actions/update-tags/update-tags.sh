#!/bin/bash

set -e

version=""

if [[ -n "$VERSION" ]]; then
    version="$VERSION"
else
    echo "VERSION not provided. Using latest tag as VERSION..."
    version="$(git tag --sort=committerdate --points-at HEAD | tail -1)"

    if [[ -z "$version" ]]; then
        echo "ERROR: Could not determine VERSION or latest tag to update."
        exit 1
    fi
fi

# We will only handle tags >= v1 in the format v{MAJOR}.{MINOR}?.{PATCH}?
#   capture 1: major number
#   capture 2: minor number with dot
#   capture 3: minor number without dot
#   capture 4: patch number with dot
#   capture 5: patch number without dot
VALID_TAG_REGEX="^v([1-9][0-9]*)(\.(0|[1-9][0-9]*)){0,1}(\.(0|[1-9][0-9]*)){0,1}$"

if [[ "$version" =~ $VALID_TAG_REGEX ]]; then
    majorTag="v${BASH_REMATCH[1]}"
    minorTag="$majorTag.${BASH_REMATCH[3]:-0}"
    patchTag="$minorTag.${BASH_REMATCH[5]:-0}"
    tags=("$majorTag" "$minorTag" "$patchTag")
else
    echo "Release tag does not match the format \"v{MAJOR}.{MINOR}?.{PATCH}?\". Skipping tag updates."
    exit 0
fi

git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"

for tag in "${tags[@]}"; do
    message="Release $patchTag"

    if [ "$(git tag -l "$tag")" ]; then
        echo "Updating tag: $tag"
        message="Update to $patchTag"
    else
        echo "Creating tag: $tag"
    fi

    git tag -fa "$tag" -m "$message"
    git push origin "$tag" --force
done