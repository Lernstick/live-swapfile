#!/bin/sh
cd po
for PO_FILE in *.po; do
	LANG_CODE="$(echo "${PO_FILE}" | sed 's/\.po$//1')"
	LOCALE_DIR="../usr/share/locale/${LANG_CODE}/LC_MESSAGES/"
	if [ ! -d "${LOCALE_DIR}" ]
	then
		mkdir -p "${LOCALE_DIR}"
	fi
	msgfmt "${PO_FILE}" -o "${LOCALE_DIR}/live-swapfile.mo"
done
