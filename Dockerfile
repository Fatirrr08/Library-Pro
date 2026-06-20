# Tahap 1: Kompilasi menggunakan Maven dan JDK 21
FROM maven:3.9.6-eclipse-temurin-21-jammy AS build
COPY . .
RUN mvn clean package -DskipTests

# Tahap 2: Jalankan menggunakan Apache Tomcat 10 dengan JDK 21
FROM tomcat:10.1-jdk21-openjdk-slim
COPY --from=build /target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]