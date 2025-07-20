REPOSITORY=/home/ec2-user/app/step2
PROJECT_NAME=freelec-springboot2-webservice

echo "> Build 파일 복사"

cp $REPOSITORY/zip/*.jar $REPOSITORY/

echo "> 현재 구동중인 애플리케이션 pid 확인"

# 수행 중인 애플리케이션 프로세스 ID => 구동 중이면 종료하기 위함.
CURRENT_PID=$(pgrep -fl $PROJECT_NAME | grep jar | awk '{print $1}')

echo "현재 구동중인 애플리케이션 pid: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
        echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
else
        echo "> kill -15 $CURRENT_PID"
        kill -15 $CURRENT_PID
        sleep 5
fi

echo "> 새 애플리케이션 배포"

JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo ">$JAR_NAME 에 실행권한 추가"

chmod +x $JAR_NAME

echo "> $JAR_NAME 실행"

nohup java -jar \
  -Dspring.config.location=\
classpath:/application.properties,\
classpath:/application-real.properties,\
/home/ec2-user/app/application-oauth.properties,\
/home/ec2-user/app/application-real-db.properties \
  -Dspring.profiles.active=real \
  $JAR_NAME > $REPOSITORY/nohup.out 2>&1 &
# CodeDeploy는 배포 스크립트에서 실행한 프로세스가 종료되어야 다음 단계로 넘어감
# 하지만 nohup은 백그라운드에서 실행되므로 별도로 표준출력을 리디렉션하지 않으면
# CodeDeploy가 nohup 명령의 표준출력을 기다리며 무한 대기하는 문제가 발생할 수 있음
#
# 따라서 아래처럼 표준출력과 표준에러를 nohup.out 또는 별도 파일로 리디렉션해야 함
# 이렇게 해야 nohup 프로세스는 백그라운드로 정상 실행되고,
# CodeDeploy는 즉시 다음 단계로 넘어갈 수 있음
