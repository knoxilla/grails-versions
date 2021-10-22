#!/bin/bash
rm -rf .git versions/
git init .
git add .
git commit -am 'Initial commit'
git remote add origin git@github.com:knoxilla/grails-versions.git
git push -u origin main -f

export SDKMAN_DIR="$HOME/.sdkman" && source "$HOME/.sdkman/bin/sdkman-init.sh"

function diffVersion() {
    sdk install grails $1
    sdk use grails $1
    grails create-app versions
    cd versions
    ./gradlew dependencyManagement > dependencyManagement.txt
    cd ..
    git add versions
    git commit -a -m $1
    git tag $1
    rm -rf versions
}

# Initial version to diff from
diffVersion 3.0.0

# 3.0.x
for i in $(seq 1 5); do
    diffVersion 3.0.$i
done

# 3.1.x
for i in $(seq 0 15); do
   diffVersion 3.1.$i
done

# 3.2.x
for i in $(seq 0 13); do
   diffVersion 3.2.$i
done

# 3.3.0.Milestone Releases
diffVersion 3.3.0.M1
diffVersion 3.3.0.M2
diffVersion 3.3.0.RC1

# 3.3.x
for i in $(seq 0 6); do
  diffVersion 3.3.$i
done

# Skip 3.3.7 as new app creation was broke
# 3.3.8+
for i in $(seq 8 9); do
  diffVersion 3.3.$i
done
diffVersion 3.3.9
diffVersion 3.3.10
diffVersion 3.3.11

diffVersion 4.0.0.M1
diffVersion 4.0.0.M2
diffVersion 4.0.0.RC1
diffVersion 4.0.0.RC2

for i in $(seq 0 12); do
  diffVersion 4.0.$i
done

# 4.1.0.Milestone Releases
diffVersion 4.1.0.M1
diffVersion 4.1.0.M2
diffVersion 4.1.0.M3
diffVersion 4.1.0.M4
diffVersion 4.1.0.M5

# 5.0.0.Milestone Releases
diffVersion 5.0.0.M1
diffVersion 5.0.0.M2
diffVersion 5.0.0.RC1
diffVersion 5.0.0.RC2
diffVersion 5.0.0.RC3
diffVersion 5.0.0.RC4

# 5.0.x
diffVersion 5.0.0
# for i in $(seq 1 x); do
#     diffVersion 5.0.$i
# done
git restore -- versions

git push origin main -f
git push origin --tags -f
