#!/bin/bash

echo -e "\033[0;32mDeploying updates to Github...\033[0m"

pushd $(dirname "$0") > /dev/null

cd www

# Build the www part
hugo

popd > /dev/null

pushd $(dirname "$0") > /dev/null

cd blog

# Build the blog part
hugo

popd > /dev/null

rm -r public 

mv www/public .

mv blog/public public/blog


# Add changes to git.
git add -A

# Commit changes.
msg="Rebuilding site `date`, to be served from the public folder"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master
