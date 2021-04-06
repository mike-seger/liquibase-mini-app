. /home/.env
. /home/db/utils.sh

# shellcheck disable=SC2016
get_mssql_user='if [ $# -gt 1 ] ; then mssql_user=${1:-$DB_USER}; shift; fi;'

unset -f mssql_sqlcmd
function mssql_sqlcmd() {
  # shellcheck disable=SC2046
  # shellcheck disable=SC2059
  # shellcheck disable=SC2086
  /opt/mssql-tools/bin/sqlcmd -s "	" $SQLCMD_OPTS "$@"
}

cmd="mssql_$1"
shift

$cmd "$@"
