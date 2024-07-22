!/bin/bash
# check if arguments were provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <hostname or IP address> ..."
  exit 1
fi

# loop through each argument and ping it in the background
for host in "$@"
do
  ping -c 1 "$host" &
  wait
done
