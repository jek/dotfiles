# -*- mode: shell-script; coding: utf-8;  -*-
# .bashrc
# <jek@discorporate.us>


if [[ -d /idealist && ! -h /idealist ]]; then
    function _family() {
        if [[ $sandbox_family ]]; then
            echo "${sandbox_family} "
        fi
    }

    export PATH=/idealist/sbin:$PATH

    function i3() {
        export PATH=$PATH:/idealist/sbin
        cd ~/work/
        export sandbox_family=i3
        codeprompt

        function i3on {
            local cur_ps1=${PS1}
            source develop
            settitle "i3:$(basename `pwd`)"
            function i3off () {
                settitle i3
                deactivate
                export PS1=${cur_ps1}
            }
        }

        # run server fast
        alias rsf='bin/invoke idealist.webapp.utilities.run_werkzeug_server --mode=dev --reloader=0 --threaded=0'

        # land in the most recently used ido branch
        for d in `/bin/ls -1td ./ido*`; do
            if [ -e $d/setup.py ]; then
                cd $d;
                break;
            fi
        done
        source /idealist/releases/sandbox-v$(make -s sandbox-version)/bin/activate.sh
        settitle i3
        settabcolor green
    }


    function i4() {
        export PATH=$PATH:/idealist/sbin
        cd ~/work/
        export sandbox_family=i4
        codeprompt

        function i4on {
            local cur_ps1=${PS1}
            source develop
            settitle "i4:$(basename `pwd`)"
        }

        # land in the most recently used ido branch
        for d in `/bin/ls -1td ./i4*`; do
            if [ -e $d/style-guide ]; then
                cd $d;
                break;
            fi
        done
        source /idealist/releases/sandbox-v$(make -s sandbox-version)/bin/activate.sh
        settitle i4
        settabcolor blue
    }
fi
