cd /home/user/Documents/personal-website
git checkout live
git merge main -m "update from main"
rm -rf public
hugo
git add .
git commit -m "build + $(date)"
git push origin
git checkout main
echo "Built and deployed on + $(date)" >> build_log.txt
