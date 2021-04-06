. /home/db/utils.sh

unset -f oracle_run_sql0
function oracle_run_sql0() {
  bash -c "$@"
}

cmd="oracle_$1"
shift

$cmd "${DB_USER}/${DB_PASSWORD}@XE" "$1" "$2"