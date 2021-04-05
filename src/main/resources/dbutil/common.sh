function dbex() {
  local container=$1; shift ;
  local cmd="$1"
  shift
  docker exec -it "$container" bash -c "/home/exec.sh $cmd '$*'"
}
