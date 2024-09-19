This is how I published quarto files on github
See: https://quarto.org/docs/publishing/github-pages.html#publish-command


# Initialise git
git init
git config --global user.name "SeiroIto"
git remote add origin https://github.com/SeiroIto/QuartoFiles.git  ## specify remote
git branch -M main

Close git once and start again. 

Before running below, create .gitignore and place it in the root of this repo/project where .git folder sits
#### .gitignore has following lines (=asking git to ignore derived files)

/**/libs


git add c:/seiro/docs/personal/Miscellaneous/QuartoFiles   ## this adds files to track

git ls-tree -r main --name-only ## list all tracked files

#### git commit -am "initial commit"
#### git push -f origin main  ## push files to remote


# Install quarto


# Automate quarto publication

## Add folders and files

/.github/workflows/publish.yml

/.quarto/

## create and switch to a branch "gh-pages"
git checkout --orphan gh-pages 
### make sure all changes are committed before running this!
git reset --hard 
git commit --allow-empty -m "Initialising gh-pages branch"
git push origin gh-pages

## Ignoring outputs

### Add to .gitignore the following lines

/.quarto/  

/_site/  

## Publishing

quarto publish gh-pages

## Push

git push origin gh-pages

