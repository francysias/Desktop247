FROM maven:3.3.9-jdk-8 AS build

WORKDIR /app
COPY . .

RUN mvn clean package -DskipTests

FROM tomcat:7.0.109-jre8

RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY --from=build /app/target/desktop-1.0.9.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
