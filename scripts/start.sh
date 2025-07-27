#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)

# 현재 start.sh가 속해있는 경로를 찾는다.
ABSDIR=$(dirname $ABSPATH)

# 일종의 import, 해당 코드로 인해 start.sh에서 profile.sh의 여러 function 사용 가능
source ${ABSDIR}/profile.sh

REPOSITORY=/home/ec2-user/app/step3
PROJECT_NAME=freelec-springboot2-webservice

echo "> Build 파일 복사"
echo "> cp $REPOSITORY/zip/*.jar $REPOSITORY/"

cp $REPOSITORY/zIp/*.jar $REPOSITORY/

echo "> 새 애플리케이션 배포"
JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> $JAR_NAME 에 실행권한 추가"

chmod +x $JAR_NAME

IDLE_PROFILE=$(find_idle_profile)

echo "> $JAR_NAME 를 profile=$IDLE_PROFILE 로 실행합니다."
nohup java -jar \
    -Dspring.config.location=\
classpath:/application.properties,\
classpath:/application-$IDLE_PROFILE.properties,\
/home/ec2-user/app/application-oauth.properties,\
/home/ec2-user/app/application-real-db.properties \
    -Dspring.profiles.active=$IDLE_PROFILE \
    $JAR_NAME > $REPOSITORY/nohup.out 2>&1 &

# 기본적인 스크립트는 step2의 deploy.sh와 유사하지만 $IDLE_PROFILE을 통해 properties를
# 그때그때 다르게 적용함