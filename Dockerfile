FROM registry.cn-hangzhou.aliyuncs.com/acs/maven:3-jdk-8 AS builder
COPY ./pom.xml pom.xml
RUN ["/usr/local/bin/mvn-entrypoint.sh","mvn","verify","clean","--fail-never"]
ADD ./src src/
RUN /usr/local/bin/mvn-entrypoint.sh mvn clean package -DskipTests

FROM openjdk:8-jdk-alpine
ENV TZ=Asia/Shanghai
COPY --from=hengyunabc/arthas:latest /opt/arthas /opt/arthas
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]
COPY --from=builder target/*.jar app.jar
CMD ["java", "-Xms512m", "-Xmx1024m", "-Dlog4j2.formatMsgNoLookups=true", "-jar", "app.jar"]