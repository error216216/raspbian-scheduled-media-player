#!/bin/bash
# Make sure script is run as root
if [ "$(id -u)" != "0" ]; then
  echo "Must be run as root with sudo! Try: sudo ./install.sh"
  exit 1
fi

echo "Checking dependencies..."
# Install MySQL and create database
if pgrep mysql; then
echo "MySQL found"
while true; do
    read -p "Do you wish to create required database and user in mysql? " yn
    case $yn in
        [Yy]* ) read -p "Please enter mysql user that can create databases and other users (ex: root): " mysqluser; read -p "Please enter mysql $mysqluser password(leave blank if you don't know): " mysqlpassword;if [[ -z "$mysqlpassword" ]]; then mysqlpassword="root"; fi; mysql -u $mysqluser -p$mysqlpassword -e "CREATE DATABASE mp3player;";mysql -u $mysqluser -p$mysqlpassword -e "CREATE USER 'orar'@'localhost' IDENTIFIED BY 'orar';";mysql -u $mysqluser -p$mysqlpassword -e "GRANT ALL PRIVILEGES ON mp3player.* to 'orar'@'localhost';";mysql -u $mysqluser -p$mysqlpassword -e "FLUSH PRIVILEGES;"; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
else 
echo "MySQL not found"
while true; do
    read -p "Do you wish to install dependency mariaDB(MySQL) program? " yn
    case $yn in
        [Yy]* ) apt-get install mariadb-client mariadb-server --yes --force-yes; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
mysql -u root -proot -e "CREATE DATABASE mp3player;";
mysql -u root -proot -e "CREATE USER 'orar'@'localhost' IDENTIFIED BY 'orar';";
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON mp3player.* to 'orar'@'localhost';";
mysql -u root -proot -e "FLUSH PRIVILEGES;";
fi
# Install apache2 php7
if pgrep apache2; then
echo "apache2 found"
while true; do
    read -p "Do you wish to install php7.0 dependency? " yn
    case $yn in
        [Yy]* ) apt-get install apache2-mod-php7.0 php7.0 php7.0-mysql --yes; break;;
        [Nn]* ) echo "Please make sure you have php7.0, php7.0-mysql, apache2, apache2-mod-php7.0 modules installed..."; sleep 5; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
else 
echo "apache2 not found"
while true; do
    read -p "Do you wish to install dependency apache2 and php7.0 ? " yn
    case $yn in
        [Yy]* ) apt-get install apache2 apache2-mod-php7.0 php7.0 php7.0-mysql --yes; break;;
        [Nn]* ) echo "Please make sure you have php7.0, php7.0-mysql, apache2, apache2-mod-php7.0 modules installed..."; sleep 5; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
fi
apt-get install python-mysqldb --yes
while true; do
    read -p "Do you wish to install resilio sync? " yn
    case $yn in
        [Yy]* ) wget https://download-cdn.getsync.com/2.0.128/PiWD/bittorrent-sync-pi-server_2.0.128_armhf.deb; sudo dpkg -i bittorrent-sync-pi-server_2.0.128_armhf.deb; rm bittorrent-sync-pi-server_2.0.128_armhf.deb; break;;
        [Nn]* ) echo "resilio sync not installed"; sleep 5; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
crontab -l > mycron
echo "@reboot /var/www/html/./program.sh" >> mycron
echo "* * * * * /var/www/html/./restart.sh" >> mycron
echo "@reboot mount -o umask=000 /dev/sda1 /home/pi/data/syncaod" >> mycron
crontab mycron
rm mycron
chmod 777 /var/www/html/
rm -vv /var/www/html/index.html
rm -vv install.sh
mv -vv index.php /var/www/html/ -f
mv -vv login.php /var/www/html/ -f
mv -vv program.sh /var/www/html/ -f
mv -vv restart.sh /var/www/html/ -f
mv -vv serverDate.js /var/www/html/ -f
chmod +x /var/www/html/program.sh
chmod +x /var/www/html/restart.sh
mkdir /home/pi/data/syncaod/
mkdir /home/pi/data/syncaod/media/
mkdir /home/pi/data/syncaod/media/1/
mkdir /home/pi/data/syncaod/media/2/
mkdir /home/pi/data/syncaod/media/3/
chmod -R 777 /home/pi/data/syncaod/media/
reboot
