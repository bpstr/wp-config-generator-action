while [ $# -gt 0 ]; do
  echo "$1";
  arg="${1#*=*}";
  val="${1#*=*}";
  echo $arg;
  echo $val;
  shift
done
