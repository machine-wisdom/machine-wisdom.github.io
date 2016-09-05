#!/bin/bash

echo -e "\033[0;32mDeploying updates to Github...\033[0m"

pushd $(dirname "$0") > /dev/null

cd www

# Build the www part
hugo

popd > /dev/null

pushd $(dirname "$0") > /dev/null

cd blog

# Build the www part
hugo

popd > /dev/null

mv www/public .

mv blog/public public/blog

# Add changes to git.
git add -A

# Commit changes.
msg="Rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

git subtree push --prefix=public git@github.com:machine-wisdom/machine-wisdom.github.io.git gh-pages
