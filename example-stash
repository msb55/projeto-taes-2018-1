git checkout master
git branch -D example-stash

git checkout -b example-stash
echo "edited on: example-stash" >> my-file.txt
git add my-file.txt
git commit -m "example-stash: edited my-file.txt"

git checkout master
echo "edited on: master" >> my-file.txt
git stash

git merge -m "Merged in example-stash" example-stash

git stash apply