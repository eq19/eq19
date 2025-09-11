#!/usr/bin/env bash
# Structure: Cell Types – Modulo 6

hr='----------------------------------------------------------------------------------'
CONTAINER="mydb"
APP="freqtrade_live"
DOCKER="/mnt/disks/deeplearning/usr/bin/docker"

echo -e "\n$hr\nFinal Space\n$hr"
df -h

set_monitor(){
  # Max retries
  max_retries=10
  # Interval between checks (10 retries in 10 minutes -> 60s each)
  interval=60

  # Path to docker binary
  DOCKER="/mnt/disks/deeplearning/usr/bin/docker"

  for ((i=1; i<=max_retries; i++)); do
    echo "Check $i of $max_retries..."

    if $DOCKER ps --format '{{.Names}}' | grep -wq "^mydb$"; then
      echo -e "\n$hr\nDeepLearning Final Cloud\n$hr" && /mnt/disks/deeplearning/usr/bin/gcloud info
      echo -e "\n$hr\n" && /mnt/disks/deeplearning/usr/bin/gcloud info --run-diagnostics
  
      echo -e "\n$hr\nDeepLearning Docker info\n$hr" && $DOCKER info
      echo -e "\n$hr\n" && $DOCKER container ls -a

      echo -e "\n$hr\nCondition fulfilled ✅"

      # Setup freqtrade userdir for dry mode
      if ! $DOCKER exec mydb test -d "/home/runner/data_dry"; then
        $DOCKER exec mydb freqtrade create-userdir --userdir /home/runner/data_dry
        $DOCKER exec mydb mkdir -p /home/runner/data_dry/strategies/utils
      elif $DOCKER exec mydb supervisorctl status freqtrade_dry | grep -q "RUNNING"; then
        $DOCKER exec mydb supervisorctl stop freqtrade_dry || true
      fi

      # Setup freqtrade userdir for live mode
      if ! $DOCKER exec mydb test -d "/home/runner/data_live"; then
        $DOCKER exec mydb freqtrade create-userdir --userdir /home/runner/data_live
        $DOCKER exec mydb mkdir -p /home/runner/data_live/strategies/utils
      elif $DOCKER exec mydb supervisorctl status freqtrade_live | grep -q "RUNNING"; then
        $DOCKER exec mydb supervisorctl stop freqtrade_live || true
        $DOCKER exec mydb supervisorctl stop monitor_freqtrade || true to 
      fi

      exit 0
    fi

    if [ $i -lt $max_retries ]; then
      wait=$((i * interval))
      sleep $wait
    fi
  done
}

if [ -d /mnt/disks/deeplearning/usr/local/sbin ]; then

  echo -e "\n$hr\nDocker images\n$hr"
  $DOCKER image ls

  echo -e "\n$hr\nNetwork images\n$hr"
  $DOCKER network inspect bridge

  RERUN_RUNNER=$(curl -s \
    -H "Authorization: token $GH_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/variables/RERUN_RUNNER" | jq -r '.value')

  REMOVE_REPOSITORY=$(curl -s \
    -H "Authorization: token $GH_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/variables/REMOVE_REPOSITORY" | jq -r '.value')

  TARGET_REPOSITORY=$(curl -s \
    -H "Authorization: token $GH_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/variables/TARGET_REPOSITORY" | jq -r '.value')

  echo -e "\n$hr\nStart Network\n$hr"
  $DOCKER exec mydb supervisorctl reread
  $DOCKER exec mydb supervisorctl update
  if [[ "$RERUN_RUNNER" == "true" ]]; then
    $DOCKER exec mydb supervisorctl start freqtrade_dry
    $DOCKER exec mydb supervisorctl start freqtrade_live
    sleep 600 && $DOCKER exec mydb supervisorctl start monitor_freqtrade
    $DOCKER exec mydb service cron start

  #Check if ✅ $APP is running inside $CONTAINER
  elif $DOCKER ps --format '{{.Names}}' | grep -q "^${CONTAINER}$" && \
    $DOCKER exec "$CONTAINER" supervisorctl status "$APP" | grep -q "RUNNING"; then

    if [[ "$CONTAINER_NAME" == "runner1" ]]; then
      $DOCKER exec runner2 /home/runner/scripts/exitpoint.sh $REMOVE_REPOSITORY $TARGET_REPOSITORY
    elif [[ "$CONTAINER_NAME" == "runner2" ]]; then
      $DOCKER exec runner1 /home/runner/scripts/exitpoint.sh $REMOVE_REPOSITORY $TARGET_REPOSITORY
    fi

  else
    # Optionally restart:
    # docker start "$CONTAINER" && docker exec "$CONTAINER" supervisorctl start "$APP"
    echo "❌ $APP is NOT running (either container is down or process crashed)."
    $DOCKER exec mydb supervisorctl start freqtrade_dry
    $DOCKER exec mydb supervisorctl start freqtrade_live
    sleep 600 && $DOCKER exec mydb supervisorctl start monitor_freqtrade
    $DOCKER exec mydb service cron start
    
  fi
fi

echo -e "\njob completed"
