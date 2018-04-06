#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# 检查是否为Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

# 检查系统信息
if [ ! -z "`cat /etc/issue | grep 'Ubuntu 16'`" ];
    then
        OS='Ubuntu'
    else
        echo "Not support OS(Ubuntu 16), Please reinstall OS and retry!"
        #exit 1
fi


## 初始化安装参数 ##

# 设置静态变量
APT_KEY='https://download.owncloud.org/download/repositories/production/Ubuntu_16.04/Release.key'
APT_SOURCE='http://download.owncloud.org/download/repositories/production/Ubuntu_16.04/'
NGINX_CONF='/etc/nginx/sites-enabled/'
OC_SITE_CONF='https://raw.githubusercontent.com/kaixinguo360/ShellScript/master/owncloud/nginx_site_conf'

# 读取用户输入
read -p '您的网站域名: ' SERVER_NAME
while true :
do
    read -s -p '请设置MySQL根密码: ' MYSQL_PASSWORD_1
    echo ''
    read -s -p '再输一遍: ' MYSQL_PASSWORD_2
    echo ''
    if [ "${MYSQL_PASSWORD_1}" = "${MYSQL_PASSWORD_2}" ]; then
        MYSQL_PASSWORD=${MYSQL_PASSWORD_1}
        break
    else
        echo -e "两次输入密码不一致!\n"
    fi
done

## 正式安装开始 ##

# 新增apt密钥
wget -nv ${APT_KEY} -O Release.key
apt-key add - < Release.key
rm -rf Release.key

# 更新apt
echo "deb ${APT_SOURCE} /" > /etc/apt/sources.list.d/owncloud.list
apt-get update

# 安装OwnCloud
apt-get install owncloud-files -y

# 安装PHP扩展插件
apt-get install php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc php-zip php-intl -y
systemctl restart php7.0-fpm


## 配置Nginx ##

# 下载配置文件
wget -O ${NGINX_CONF}owncloud ${OC_SITE_CONF}

# 修改配置文件
sed -i "s/TMP_SERVER_NAME/${SERVER_NAME}/g" ${NGINX_CONF}owncloud























