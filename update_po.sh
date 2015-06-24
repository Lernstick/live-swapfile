#!/bin/sh
xgettext -L Shell --add-comments=## etc/init.d/live-swapfile usr/sbin/live-mkswapfile
msgmerge -U po/de/live-swapfile.po messages.po
rm messages.po
