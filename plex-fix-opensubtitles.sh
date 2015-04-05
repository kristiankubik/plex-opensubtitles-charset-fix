#!/bin/bash

USER='root'
PLEX_PATH="/opt/plex"
MEDIA_PATH="Library/ApplicationSupport/Plex Media Server/Media/localhost/"

# skontrolujeme uzivatela
if [ `whoami` != $USER ]; then
	if id -u $USER >/dev/null 2>&1; then
		if su $USER; then
			echo "login success!"
		else 
			echo "neplatny login"
			exit 0
		fi
	else
		echo "User $USER neexistuje!"
		exit 0
	fi
fi

cd "$PLEX_PATH/$MEDIA_PATH"

find . -name '*.srt' -path '*/cs/*' -type f | while read line; do
	#echo "$line"
	SUB_FILE=$(basename "$line")
	if [ -f "$line.bak" ]; then
		echo "- Skipping $SUB_FILE"
	else
		echo "+ Processing $SUB_FILE"
		cp "$line" "$line.bak"
		iconv -c -f cp1250 -t UTF8//TRANSLIT "$line" > "$line.2"
		mv "$line.2" "$line"
		chmod 777 "$line"
	fi
done

