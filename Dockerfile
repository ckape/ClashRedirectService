FROM maven:3.8.4-jdk-11 AS builder
ADD ./pom.xml pom.xml
ADD ./src src/
RUN mvn clean package -Dmaven.test.skip=true

FROM openjdk:11-jdk-slim
ENV TZ=Asia/Shanghai
WORKDIR /app
COPY  --from=builder target/*.jar /app/app.jar
COPY --from=hengyunabc/arthas:latest /opt/arthas /opt/arthas
CMD ["java", "-Xms512m", "-Xmx1024m", "-Dlog4j2.formatMsgNoLookups=true", "-jar", "app.jar"]