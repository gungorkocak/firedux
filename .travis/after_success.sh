#!/bin/bash

# Exit unless default Node version (don't run for each one)
[ "${TRAVIS_NODE_VERSION}" = "node" ] && exit 1

# Exit if this is a pull request (T.B.D. - will it run again?)
[ "${TRAVIS_PULL_REQUEST}" = "true" ] && exit 1

echo "Not a pull request..."

GIT_CHANGED_FILES=`git diff --name-only HEAD^`

echo "Git changed files:"
echo $GIT_CHANGED_FILES
echo

# Exit unless README.md changed.
( echo $GIT_CHANGED_FILES | grep README.md >> /dev/null ) && exit 1


echo "Setting git user..."

git config user.name "Travis CI"
git config user.email "adjohnson916@users.noreply.github.com"

echo "Running verb..."

npm run verb

[ $? -ne 0 ] && exit 1

echo "Verb complete."
echo "Git operations..."

echo "Git checkout... branch=$TRAVIS_BRANCH"
git checkout $TRAVIS_BRANCH

echo "Git add..."
git add README.md
[ $? -ne 0 ] && exit 1
echo "Git commit..."
git commit -m "Build README.md from Travis."
[ $? -ne 0 ] && exit 1
echo "Git push..."
git push -q "https://${GITHUB_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git" $TRAVIS_BRANCH 2>&1 > /dev/null

