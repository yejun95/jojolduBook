#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)

# 현재 stop.sh가 속해있는 경로를 찾는다.
ABSDIR=$(dirname $ABSPATH)

# 일종의 import, 해당 코드로 인해 stop.sh에서 profile.sh의 여러 function 사용 가능
source ${ABSDIR}/profile.sh

IDLE_PORT=$(find_idle_port)

echo "> $IDLE_PORT 에서 구동 중인 애플리케이션 pid 확인"
IDLE_PID=$(lsof -ti tcp:${IDLE_PORT})

if [ -z ${IDLE_PID} ]
then
  echo "> 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다."
else
  echo "> kill -15 $IDLE_PID"
  kill -15 ${IDLE_PID}
  sleep 5
fi

# 해당 파일은 Nginx와 연결되어 있지 않은 포트가 실행되고 있을 수도 있으니 강제 종료 함
