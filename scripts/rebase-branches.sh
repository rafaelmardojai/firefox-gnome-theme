#!/bin/sh

git checkout beta
git rebase master
git push origin beta -f

git checkout nightly
git rebase beta
git push origin nightly -f

git checkout master

