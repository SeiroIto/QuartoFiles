This is how I published quarto files on github
See: https://quarto.org/docs/publishing/github-pages.html#publish-command

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

quarto publish gh-pages test2.qmd

## Push

git push origin gh-pages

