#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
source ${ABSDIR}/profile.sh

function switch_proxy() {
    IDLE_PORT=$(find_idle_port)

    echo "> 전환할 Port: $IDLE_PORT"
    echo "> Port 실행"

    # Nginx 설정에서 사용할 #service_url 값을 지정하는 설정 문자 > 해당 내용을 service-url.inc 파일에 쓴다.
    echo "set \$service_url http://127.0.0.1:${IDLE_PORT};" | sudo tee /etc/nginx/conf.d/service-url.inc

    echo "> Nginx reload"
    sudo service nginx reload
}