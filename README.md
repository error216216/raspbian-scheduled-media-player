# raspbian-scheduled-media-player
A player for raspbian that supports .mp4 .avi .mkv .mp3 .mov .mpg .flv .m4v .divx file formats via omxplayer from 3 folders that can have separate schedules controlled via web.
It outputs audio to HDMI and Jack and video(if available) to HDMI.

This project was designed to be installed on a fresh install of raspbian and not to have any other tasks running.

Important Notes:

The 3 folders must be at the following locations(they are created during setup):
/home/pi/data/syncaod/media/1/
/home/pi/data/syncaod/media/2/
/home/pi/data/syncaod/media/3/

If there is a USB drive inserted, at boot it will be mounted at the following location:
/home/pi/data/syncaod/

The USB drive will not be mounted if it is ntfs or exfat format.

The program will recognize the following folders in the USB drive:
/media/1/
/media/2/
/media/3/

The files can either be put in the specified folders or Resilio sync can be used to sync them, the setup installs it if the prompt is yes.
Resilio is accesible on port 8888.
The initial user and password for the schedule interface is "orar" without brackets, and can be changed in the login.php file.

Installation instructions:

Download the files with command:
git clone https://github.com/error216216/raspbian-scheduled-media-player.git

Go to download location:
cd raspbian-scheduled-media-player

Make the install.sh executable:
chmod +x install.sh

Run installer with command:
sudo ./install.sh

It will ask you to install dependencies: mariaDB, apache2, php7.
Caution, during install the following files will be overwritten: index.php and index.html from /var/www/html/ , if it's a new install you have nothing to worry about.

