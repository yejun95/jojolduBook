#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
source ${ABSDIR}/profile.sh
source ${ABSDIR}/switch.sh

IDLE_PORT=$(find_idle_port)

echo "> Health Check Start"
echo "> IDLE_PORT: $IDLE_PORT"
echo "> curl -s http://localhost:$IDLE_PORT/profile "
sleep 10

for RETRY_COUNT in {1..10}
do
  RESPONSE=$(curl -s http://localhost:${IDLE_PORT}/profile)
  UP_COUNT=$(echo ${RESPONSE} | grep 'real' | wc -l)

  if [ ${UP_COUNT} -ge 1 ]
  then # $up_count >= 1 ("real1" 문자열이 있는지 검증)
      echo "> Health check 성공"
      switch_proxy
      break
  else
      echo "> Health check의 응답을 알 수 없거나 혹은 실행 상태가 안비니다."
      echo "> Health check: ${RESPONSE}"
  fi

  if [ ${RETRY_COUNT} -eq 10 ]
  then
      echo "> Health check 실패."
      echo "> Nginx에 연결하지 않고 배포를 종료합니다."
      exit 1
  fi

  echo "> Health check 연결 실패. 재시도..."
  sleep 10
done

# 1. Nginx와 연결되지 않은 포트로 스프링부트가 잘 수행되었는지 체크
# 2. 잘 떴는지 확인되어야 Nginx proxy 설정을 변경(switch_proxy)합니다.
# 3. Nginx proxy 설정 변경은 switch.sh에서 수행합니다.