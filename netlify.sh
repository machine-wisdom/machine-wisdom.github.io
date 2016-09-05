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
