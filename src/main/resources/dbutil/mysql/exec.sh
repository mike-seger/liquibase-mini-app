. /home/.env
. /home/db/utils.sh

mysql_user=${DB_USER}
# shellcheck disable=SC2016
get_mysql_user='if [ $# -gt 1 ] ; then mysql_user=$1; shift; fi;'

unset -f mysql_mysql
function mysql_mysql() {
  mysql "$@"
}

cmd="mysql_$1"
shift

eval "$get_mysql_user"
$cmd "$mysql_user" "$@"
