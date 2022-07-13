pushd ~/yuaneg.github.io
git pull
ipold=`grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' index.html`
ip=`curl ifcfg.cn`
if [ "$ip" != "$ipold" ];then
  sed -i s/$ipold/$ip/g index.html
  git add .
  git commit -m change
  git push
fi
