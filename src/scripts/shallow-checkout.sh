#!/bin/bash

# SHALLOW_CHECKOUT
mkdir -p $HOME/.ssh
ssh-keyscan -H github.com >> ~/.ssh/known_hosts
cd ... || exit
rm -r ~/project
BRANCH=$CIRCLE_BRANCH
if [ -z "$BRANCH" ];
then
BRANCH=$CIRCLE_TAG
fi
git clone --single-branch --depth 1 "$CIRCLE_REPOSITORY_URL" --branch "$BRANCH" ~/project