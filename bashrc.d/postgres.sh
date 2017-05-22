
function pgps() {
    echo "select procpid,usename,current_query,waiting from pg_stat_activity" |\
        psql i3
}

function pgkill() {
    echo "select pg_cancel_backend($1);" | psql ${2:-i3}
}
