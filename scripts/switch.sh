#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)

# 현재 switch.sh가 속해있는 경로를 찾는다.
ABSDIR=$(dirname $ABSPATH)

# 일종의 import, 해당 코드로 인해 switch.sh에서 profile.sh의 여러 function 사용 가능
source ${ABSDIR}/profile.sh

function switch_proxy() {
    IDLE_PORT=$(find_idle_port)

    echo "> 전환할 Port: $IDLE_PORT"
    echo "> Port 실행"

    # Nginx 설정에서 사용할 #service_url 값을 지정하는 설정 문자 > 해당 내용을 service-url.inc 파일에 쓰기
    echo "set \$service_url http://127.0.0.1:${IDLE_PORT};" | sudo tee /etc/nginx/conf.d/service-url.inc

    echo "> Nginx reload"
    sudo service nginx reload
}