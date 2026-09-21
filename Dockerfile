FROM maven:3.9.6-eclipse-temurin-8 AS build

WORKDIR /app

COPY pom.xml .
COPY external ./external
RUN mvn dependency:go-offline -DskipTests || true

COPY . .

RUN mvn clean package -DskipTests

FROM tomcat:7.0.109-jre8-openjdk

RUN rm -rf /usr/local/tomcat/webapps/ROOT \
    && rm -rf /usr/local/tomcat/webapps/ROOT.war

COPY --from=build /app/target/desktop-1.0.9.war \
    /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
