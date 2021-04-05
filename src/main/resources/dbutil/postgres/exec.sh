. /home/utils.sh

unset -f postgres_psql
function postgres_psql() {
  psql "$@"
}

cmd="postgres_$1"
shift

# shellcheck disable=SC2154
eval "$get_pg_user"
# shellcheck disable=SC2154
$cmd "$pg_user" "$*"
