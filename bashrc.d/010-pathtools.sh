# Path cleaner: strip out blanks and non-existent dirs; always pass
# thru relative dirs; for absolute, only use the first instance,
# counting physically (by inode)
function echo3 {
    echo $3
}
function pathclean {
    local cmd
    if which perl >/dev/null; then
        cmd=perl
    else
        cmd=echo3
    fi
    $cmd -e '@path=split(/:/, $ARGV[0]); foreach (@path) {next unless $_; if (m:^/:) {next unless -d || -l; $id=join("/", (stat _)[1..2])} else {$id=$_} unless ($path{$id}) {s:(.)/$:$1:; $path{$id}=$_; push(@final, $_);}} print join(":", @final), "\n"' $1
}

export CDPATH=.

export PATH=`pathclean \
.:$HOME/bin\
:$HOME/.gem/ruby/1.8/bin\
:/opt/local/bin\
:$JAVA_HOME/bin\
:/usr/etc:/usr/sbin\
:/usr/ccs/bin:/opt/bin:/usr/bin\
:/usr/local/bin\
:/sbin:/usr/sbin:/usr/local/sbin:/etc:/usr/etc\
:$PATH`

## Set MANPATH
export MANPATH=`pathclean \
.:~/lib/man\
:/opt/local/share/man\
:/usr/local/share/man:/usr/local/man\
:/usr/man:/usr/catman:/usr/share/man\
:/usr/X11R6/man\
:$MANPATH`
