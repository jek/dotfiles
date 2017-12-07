# -*- shell-script-mode -*-
# .bash_profile
# <jek@discorporate.us>

[[ $UID = 0 ]] && exit

if [ -z "$ENVONLY" ]
then
    [[ -t 0 ]] && stty intr '^C' susp '^Z' echoe
fi

if which keychain 2>&1 >/dev/null; then
  keychain -q ~/.ssh/id_???
fi

umask 002
if ([[ $MACHTYPE = x86_64-apple-darwin10.0 ]]) then
  ulimit -n 2048
fi

. ~/.bashrc

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
for f in /Applications/Docker.app/Contents/Resources/etc/*bash-completion; do
  source $f
done