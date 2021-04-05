. /home/utils.sh

unset -f oracle_run_sql0
function oracle_run_sql0() {
  bash -c "$@"
}

cmd="oracle_$1"
shift

$cmd "${ORA_DB_USER}/${ORA_DB_PWD}@XE" "$1" "$2"