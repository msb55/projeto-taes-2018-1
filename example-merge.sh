git checkout master
git branch -D example-merge

# criar branch
git checkout -b example-merge
# criar arquivo
echo "created on: example-merge" > merge-file.txt
# add arquivo
git add merge-file.txt
# commit
git commit -m"example-merge: added merge-file.txt"

# alterar branch
git checkout master
# criar arquivo
echo "created on: master" > merge-file.txt
# add arquivo
git add merge-file.txt
# commit
git commit -m"master: added merge-file.txt"

# merge
git merge -m "Merged in example-merge" example-merge
