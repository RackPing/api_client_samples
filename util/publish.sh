#!/bin/bash

# Program: publish.sh
# Purpose: publish RackPing REST API sample programs to github
# Usage: ./publish.sh
# Copyright: RackPing USA 2020
# Date: 2020 10 05
# Env: bash
# Note: run this file from above the git folder to publish (copy files from internal folders to git)

origin="/home/rackping/api/api_client_samples"
target="api_client_samples"

rm -f $origin/golang/bin/rp_*
find $origin/rust -name target -exec rm -fr {} \;

mkdir -p $target

for i in $origin/*; do
   if [ -d $i ]; then
      echo $i
      cp -pr $i $target
   fi
done

for i in demo_all.sh README.md; do
   echo $i
   cp -pr $origin/$i $target
done

cp -p $origin/set.template $target/set.sh

mv $target/Docker/env.list.template $target/Docker/env.list

rm -fr $target/vendor $target/php_phan $target/doc $target/test
for i in target bkp Cargo.lock; do
   find $target/rust/ -name $i -exec rm -fr {} \;
done

rm $target/java/*.class
find $target -name bkp -exec rm -fr {} \;
find $target -name "*.bkp" -exec rm -fr {} \;

chmod 755 $target/*.sh

cd $target

git add .
git commit -m "initial commit"
git push origin

echo "https://github.com/RackPing/api_client_samples"
exit 0
