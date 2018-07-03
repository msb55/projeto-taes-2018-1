git checkout master
git branch -D example-rebase

git checkout -b example-rebase
echo "created on: example-rebase" > rebase-file.txt
git add rebase-file.txt
git commit -m "example-rebase: added rebase-file.txt"

git checkout master
echo "created on: master" > rebase-file.txt
git add rebase-file.txt
git commit -m "master: added rebase-file.txt"

git rebase example-rebase
