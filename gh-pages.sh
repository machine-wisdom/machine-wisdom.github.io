#!/bin/bash

./netlify.sh

git subtree push --prefix=public git@github.com:machine-wisdom/machine-wisdom.github.io.git gh-pages
