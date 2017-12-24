#!/bin/bash
if pgrep omxplayer; then
  echo "Stopping"
  pkill omxplayer
  pkill program
  exit;
fi

# Variables
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
AUDIO_OUTPUT=both # hdmi, local, both if no config.txt
VOLUME=0

# External config
if [ -f /var/www/html/config.txt ]; then
  source /var/www/html/config.txt
fi

# Variables
MEDIA_PATH=/home/pi/data/syncaod/media
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

# Functie operatiuni efectuate la iesire
onExit()
{
  setterm -cursor on
  IFS=$SAVEIFS
  exit $?
}

# Blocheaza keyboard interrupt (ctrl-c)
trap onExit SIGINT

# Loop
while true; do
	if pgrep omxplayer; then
		pkill omxplayer
		sleep 1;
	else
		# pentru fiecare fisier
		ora=$(date +%-k)
		if [ -f /var/www/html/config.txt ]; then
		source /var/www/html/config.txt
		fi
		if ([ $ora -ge $f11 ] && [ $ora -lt $f10 ]); then
			echo -e "Playing folder 1:\n"
			index=0
			for f in `ls $MEDIA_PATH/1 | grep ".mp4$\|.avi$\|.mkv$\|.mp3$\|.mov$\|.mpg$\|.flv$\|.m4v$\|.divx$"`; do
				lista[$index]=$f
				echo "file_$index = "${lista[$index]}
				if ([ $ora -ge $f11 ] && [ $ora -lt $f10 ] && [ $index -ge '1' ] && [ $random -eq 0 ]); then
				echo -e "\nPlaying $MEDIA_PATH/1/"${lista[$(($index))]}
				omxplayer --vol $VOLUME -b --no-keys --no-osd -o $AUDIO_OUTPUT "$MEDIA_PATH/1/${lista[$(($index))]}"
				source /var/www/html/config.txt
				fi
				let "index += 1"
			done
			if ([ $ora -ge $f11 ] && [ $ora -lt $f10 ] && [ $index -ge '1' ] && [ $random -eq 1 ]); then
				echo -e "\nPlaying $MEDIA_PATH/1/"${lista[$((RANDOM % $index))]}
				omxplayer --vol $VOLUME -b --no-keys --no-osd -o $AUDIO_OUTPUT "$MEDIA_PATH/1/${lista[$((RANDOM % $index))]}"
				source /var/www/html/config.txt
			fi
		elif ([ $ora -ge $f21 ] && [ $ora -lt $f20 ]); then
			echo -e "Playing folder 2:\n"
			index=0
			for f in `ls $MEDIA_PATH/2 | grep ".mp4$\|.avi$\|.mkv$\|.mp3$\|.mov$\|.mpg$\|.flv$\|.m4v$\|.divx$"`; do
				lista[$index]=$f
				echo "file_$index = "${lista[$index]}
				if ([ $ora -ge $f21 ] && [ $ora -lt $f20 ] && [ $index -ge '1' ] && [ $random -eq 0 ]); then
				echo -e "\nPlaying $MEDIA_PATH/2/"${lista[$(($index))]}
				omxplayer --vol $VOLUME -b --no-keys --no-osd -o $AUDIO_OUTPUT "$MEDIA_PATH/2/${lista[$((RANDOM % $index))]}"
				source /var/www/html/config.txt
				fi
				let "index += 1"
			done
			if ([ $ora -ge $f21 ] && [ $ora -lt $f20 ] && [ $index -ge '1' ] && [ $random -eq 1 ]); then
				echo -e "\nPlaying $MEDIA_PATH/2/"${lista[$((RANDOM % $index))]}
				omxplayer --vol $VOLUME -b --no-keys --no-osd -o $AUDIO_OUTPUT "$MEDIA_PATH/2/${lista[$((RANDOM % $index))]}"
				source /var/www/html/config.txt
			fi
		elif ([ $ora -ge $f31 ] && [ $ora -lt $f30 ]); then
			echo -e "Playing folder 3:\n"
			index=0
			for f in `ls $MEDIA_PATH/3 | grep ".mp4$\|.avi$\|.mkv$\|.mp3$\|.mov$\|.mpg$\|.flv$\|.m4v$\|.divx$"`; do
				lista[$index]=$f
				echo "file_$index = "${lista[$index]}
				if ([ $ora -ge $f31 ] && [ $ora -lt $f30 ] && [ $index -ge '1' ] && [ $random -eq 0 ]); then
				echo -e "\nPlaying $MEDIA_PATH/3/"${lista[$(($index))]}
				omxplayer --vol $VOLUME -b --no-keys --no-osd -o $AUDIO_OUTPUT "$MEDIA_PATH/3/${lista[$((RANDOM % $index))]}"
				source /var/www/html/config.txt
				fi
				let "index += 1"
			done
			if ([ $ora -ge $f31 ] && [ $ora -lt $f30 ] && [ $index -ge '1' ] && [ $random -eq 1 ]); then
				echo -e "\nPLaying $MEDIA_PATH/3/"${lista[$((RANDOM % $index))]}
				omxplayer --vol $VOLUME -b --no-keys --no-osd -o $AUDIO_OUTPUT "$MEDIA_PATH/3/${lista[$((RANDOM % $index))]}"
				source /var/www/html/config.txt
			fi
		else
			echo "Waiting..."
		fi
		echo "Current_Hour=$ora,Foler1_Start=$f11,Folder1_Stop=$f10,Folder2_Start=$f21,Folder2_Stop=$f20,Folder3_Start=$f31,Folder3_Stop=$f30"
		sleep 1;
		setterm -foreground white --clear all
	fi
done

# Se executa la iesire
onExit
