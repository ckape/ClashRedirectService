FROM maven:3.8.4-jdk-11 AS builder
ADD ./pom.xml pom.xml
ADD ./settings.xml /root/.m2/settings.xml
ADD ./src src/
RUN mvn clean package -Dmaven.test.skip=true

FROM openjdk:11-jdk-slim
WORKDIR /app
COPY  --from=builder target/aiui-midea-proxy-0.0.1-SNAPSHOT.jar /app/app.jar
COPY --from=hengyunabc/arthas:latest /opt/arthas /opt/arthas
RUN  echo "Asia/Shanghai" > /etc/timezone;dpkg-reconfigure -f noninteractive tzdata
CMD ["java", "-Xms512m", "-Xmx1024m", "-Dlog4j2.formatMsgNoLookups=true", "-jar", "app.jar"]