#!/bin/bash

USER='root'
BACKUP_EXTENSION='bak'
SUPPORTED_LANGUAGES=('cs' 'sk')
LIBRARY_PATH="/opt/plex/Library/ApplicationSupport/Plex Media Server/Media/"

# check user
if [ `whoami` != $USER ]; then
	if id -u $USER >/dev/null 2>&1; then
		if su $USER; then
			echo "login success!"
		else 
			echo "failed"
			exit 0
		fi
	else
		echo "User $USER does not exist!"
		exit 0
	fi
fi

cd "$LIBRARY_PATH"
for lang in SUPPORTED_LANGUAGES; do
	find . -name '*.srt' -path '*/$lang/*' -type f | while read line; do
		SUB_FILE=$(basename "$line")
		if [ -f "$line.$BACKUP_EXTENSION" ]; then
			echo "- Skipping $SUB_FILE"
		else
			echo "+ Processing $SUB_FILE"
			cp "$line" "$line.$BACKUP_EXTENSION"
			iconv -c -f cp1250 -t UTF8//TRANSLIT "$line" > "$line.2"
			mv "$line.2" "$line"
			chmod 777 "$line"
		fi
	done
done
