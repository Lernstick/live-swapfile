#!/bin/sh
xgettext -L Shell --add-comments=## etc/init.d/live-swapfile usr/sbin/live-mkswapfile
for ${PO_FILE} in po/*.po; do
  msgmerge -U "${PO_FILE}" messages.po
done
rm messages.po
