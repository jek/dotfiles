# CLASSPATH cleaner: like pathclean, but allows jar files as well.
function classpathclean {
    local cmd
    if which perl >/dev/null; then
        cmd=perl
    else
        cmd=echo3
    fi
    $cmd -e '@path=split(/:/, $ARGV[0]); foreach (@path) {next unless $_; if (m:^/:) { next unless -f || -d || -l; next if -f && not m:jar$:; $id=join("/", (stat _)[1..2])} else {$id=$_} unless ($path{$id}) {s:(.)/$:$1:; $path{$id}=$_; push(@final, $_);}} print join(":", @final), "\n"' $1
}

function jarcollector {
    local jarpath
    for i in $*; do
        local jars
        jars=`find $i -type f -name '*.jar' 2>/dev/null`;
        if [ "x$jars" != "x" ]; then
            jarpath=$jarpath:`echo $jars | perl -0777ane '$,=":";print @F'`
        fi
    done
    classpathclean $jarpath
}
