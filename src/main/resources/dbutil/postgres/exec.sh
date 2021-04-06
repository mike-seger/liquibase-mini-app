. /home/.env
. /home/db/utils.sh

unset -f postgres_psql
function postgres_psql() {
  psql "$@"
}

cmd="postgres_$1"
shift

# shellcheck disable=SC2154
$cmd "$@"
