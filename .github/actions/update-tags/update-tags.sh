#!/bin/bash

set -e

: "${RELEASE_TAG_NAME?Release tag name not set.}"
echo "New release tag is: $RELEASE_TAG_NAME"

createOrUpdateTag() {
    tagName=$1

    if [ $(git tag -l $tagName) ]; then
        echo "Updating tag: $tagName"
    else
        echo "Creating tag: $tagName"
    fi

    git tag -a "$tagName" -m "Release $RELEASE_TAG_NAME" -f
}

IFS='.' read -a vers <<< "$RELEASE_TAG_NAME"

# TODO: Check tag format

majorTag=${vers[0]}
minorTag="$majorTag.${vers[1]:-0}"
patchTag="$minorTag.${vers[2]:-0}"

tags=($majorTag $minorTag $patchTag)

git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"

for tag in "${tags[@]}"; do
    createOrUpdateTag "$tag";
done

git push --force origin --tags