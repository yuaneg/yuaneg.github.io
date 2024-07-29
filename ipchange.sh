#!/bin/bash
cd /root/yuaneg.github.io
ipold=`grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' index.html`
port=4998
# Try to connect to the specified host and port using telnet
output=$( (echo quit | timeout 5  telnet $ipold $port) 2>&1 )
# Check the output of the telnet command
if [[ $output == *"Connected to"* ]]; then
    echo "$port $ipold "
else
    echo "Port $port on $ipold is closed or unreachable"
    git reset --hard HEAD
    git pull
    curl -k  -c cookie.txt  --location --request POST 'http://192.168.1.1:8080/login.cgi' \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --header 'Origin: null' \
    --header 'Upgrade-Insecure-Requests: 1' \
    --header 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36' \
    --header 'sec-ch-ua: "Google Chrome";v="105", "Not)A;Brand";v="8", "Chromium";v="105"' \
    --header 'sec-ch-ua-mobile: ?0' \
    --header 'sec-ch-ua-platform: "macOS"' \
    --header 'Cookie: Cookie=sid=372360bab4b010cac773452579848832aede09263e71be2240e8bec036be1cbe:Login:id=1' \
    --data-urlencode 'UserName=useradmin' \
    --data-urlencode 'PassWord=YmoyQzNENDc=' \
    --data-urlencode 'Language=chinese' \
    --data-urlencode 'x.X_HW_Token=5b509deb65e703c34b44e54a67d06eac'
    abc=`curl -b @cookie.txt http://192.168.1.1:8080/html/bbsp/common/wan_list.asp\?434920`
    result=`echo ${abc//\\\\x2e/\.}`
    echo $result
    echo 旧ip$ipold
    ip=`echo $result | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | awk 'NR==6{print $1}'`
    echo 新ip$ip
    if [ "$ip" != "" -a  "$ip" != "$ipold" ];then
      sed -i s/$ipold/$ip/g index.html
      git add .
      git commit -m change
    fi
    git push
fi


