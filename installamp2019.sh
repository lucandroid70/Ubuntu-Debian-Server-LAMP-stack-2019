#!/usr/bin/env bash
# Script created by Luca Sabato lucandroid70@gmail.com, the password of MySql root is root --- change immediatly, the script install
# Nextcloud in your new server into : https://YOUR_IP/nexcloud : the password of MySql nexcloud is nexcloud --- change immediatly, the script install
# PhpMyAdmin in your new server into : https://YOUR_IP/phpmyadmin : the password of MySql root is root --- change immediatly, the script install
# Remeber my, my address BTC : 1LrtHNBBiKux7LW6yyAo6MvL7b48jBbcpU  -   ETH: 0x5c0f728deeebcae23d58c024c23d99b5a1ca1752


Update () {
    echo "-- Update packages --"
    sudo apt update
    sudo apt upgrade -y
    sudo apt install git -y
    sudo apt install build-essential -y
    sudo apt install wget curl -y
    sudo apt install unzip -y
}
Update

echo "-- Prepare configuration for MySQL --"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

echo "-- Install tools and helpers --"
sudo apt-get install -y --force-yes python-software-properties vim htop curl git npm build-essential libssl-dev

echo "-- Install PPA's --"
sudo add-apt-repository ppa:ondrej/php
sudo add-apt-repository ppa:chris-lea/redis-server
Update

echo "-- Install NodeJS --"
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

echo "-- Install packages --"
sudo apt-get install -y --force-yes apache2 mysql-server-5.7 git-core nodejs
sudo apt-get install -y --force-yes php7.1-common php7.1-dev php7.1-json php7.1-opcache php7.1-cli libapache2-mod-php7.1
sudo apt-get install -y --force-yes php7.1 php7.1-mysql php7.1-fpm php7.1-curl php7.1-gd php7.1-mcrypt php7.1-mbstring
sudo apt-get install -y --force-yes php7.1-bcmath php7.1-zip
sudo apt-get install -y php7.1-xml
sudo apt-get install -y mc
Update

echo "-- Configure PHP &Apache --"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/apache2/php.ini
sudo a2enmod rewrite

echo "-- Creating virtual hosts --"
#sudo ln -fs /vagrant/public/ /var/www/app
cat << EOF | sudo tee -a /etc/apache2/sites-available/default-ssl.conf
<Directory "/var/www/html">
    AllowOverride All
</Directory>
<VirtualHost *:443>
    DocumentRoot /var/www/html/phpmyadmin
    ServerName phpmyadmin
</VirtualHost>
EOF

echo "-- Creating virtual hosts --"
#sudo ln -fs /vagrant/public/ /var/www/app
cat << EOF | sudo tee -a /etc/apache2/sites-available/nextcloud.conf
<Directory "/var/www/html/nextcloud">
    AllowOverride All
</Directory>
<VirtualHost *:443>
    DocumentRoot /var/www/html/nextcloud
    ServerName nextcloud
</VirtualHost>
EOF


echo "-- Creating virtual hosts --"
#sudo ln -fs /vagrant/public/ /var/www/app
cat << EOF | sudo tee -a /etc/apache2/sites-available/wordpress.conf
<Directory "/var/www/html/wordpress">
    AllowOverride All
</Directory>
<VirtualHost *:443>
    DocumentRoot /var/www/html/wordpress
    ServerName wordpress
</VirtualHost>
EOF

echo "-- Creating virtual hosts --"
#sudo ln -fs /vagrant/public/ /var/www/app
cat << EOF | sudo tee -a /etc/apache2/sites-available/lucandroid70.conf
<Directory "/var/www/html/lucandroid70.com">
    AllowOverride All
</Directory>
<VirtualHost *:443>
    DocumentRoot /var/www/html/lucandroid70.com
    ServerName wordpress
</VirtualHost>
EOF




mkdir -p /var/www/html/nextcloud
chown -R www-data:www-data /var/www/html/nextcloud
chmod -R 750 /var/www/html/nextcloud


mkdir -p /var/www/html/wordpress
chown -R www-data:www-data /var/www/html/wordpress
chmod -R 750 /var/www/html/wordpress

mkdir -p /var/www/html/lucandroid70.com
chown -R www-data:www-data /var/www/html/lucandroid70.com
chmod -R 750 /var/www/html/lucandroid70.com


sudo a2enmod ssl
sudo a2ensite default-ssl
sudo a2ensite nextcloud.conf
sudo a2ensite wordpress.conf
sudo a2ensite lucandroid70.com
sudo service apache2 reload
sudo service apache2 restart

echo "-- Restart Apache --"
sudo /etc/init.d/apache2 restart

#echo "-- Install Composer --"
#curl -s https://getcomposer.org/installer | php
#sudo mv composer.phar /usr/local/bin/composer
#sudo chmod +x /usr/local/bin/composer

echo "-- Install phpMyAdmin --"
wget -k https://files.phpmyadmin.net/phpMyAdmin/4.8.5/phpMyAdmin-4.8.5-all-languages.tar.gz
sudo tar -xzvf phpMyAdmin-4.8.5-all-languages.tar.gz -C /var/www/
sudo rm phpMyAdmin-4.8.5-all-languages.tar.gz
sudo mv /var/www/phpMyAdmin-4.8.5-all-languages/ /var/www/html/phpmyadmin

chown -R www-data:www-data /var/www/html/phpmyadmin
chmod -R 750 /var/www/html/phpmyadmin


wget -k https://download.nextcloud.com/server/releases/latest.tar.bz2
tar -xjf latest.tar.bz2 -C /var/www/html/
#sudo mv nextcloud/ /var/www/html/nextcloud


chown -R www-data:www-data /var/www/html/nextcloud
chmod -R 750 /var/www/html/nextcloud



chown -R www-data:www-data /var/www/html/lucandroid70.com
chmod -R 750 /var/www/html/lucandroid70.com



echo "-- Setup databases --"

mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION'";
mysql -uroot -proot -e "FLUSH PRIVILEGES";
mysql -uroot -proot -e "CREATE DATABASE my_database";
mysql -uroot -proot -e "FLUSH PRIVILEGES";


mysql -uroot -proot -e "CREATE USER 'luca2'@'localhost' IDENTIFIED BY 'MyPassword70'";
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'luca2'@'localhost' WITH GRANT OPTION"; 
mysql -uroot -proot -e "CREATE DATABASE luca2";
mysql -uroot -proot -e "FLUSH PRIVILEGES";
mysql -uroot -proot -e "SET PASSWORD FOR 'luca2'@'localhost' = PASSWORD('MyPassword70')";


mysql -uroot -proot -e "CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY 'nextcloud'";
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'nextcloud'@'localhost' WITH GRANT OPTION"; 
mysql -uroot -proot -e "CREATE DATABASE nextcloud";
mysql -uroot -proot -e "FLUSH PRIVILEGES";
mysql -uroot -proot -e "SET PASSWORD FOR 'nextcloud'@'localhost' = PASSWORD('nextcloud')";


sudo service apache2 reload
sudo service apache2 restart
sudo service mysql reload
sudo service mysql restart
