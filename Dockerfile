# Tahap 1: Kompilasi menggunakan Maven dan JDK 21
FROM maven:3.9.6-eclipse-temurin-21-jammy AS build
COPY . .
RUN mvn clean package -DskipTests

# Tahap 2: Jalankan menggunakan Apache Tomcat 10 dengan JDK 21
FROM tomcat:10.1-jdk21-openjdk-slim

# Install MySQL client untuk healthcheck
RUN apt-get update && apt-get install -y --no-install-recommends default-mysql-client && rm -rf /var/lib/apt/lists/*

COPY --from=build /target/*.war /usr/local/tomcat/webapps/ROOT.war
COPY wait-for-mysql.sh /usr/local/bin/wait-for-mysql.sh
RUN chmod +x /usr/local/bin/wait-for-mysql.sh

EXPOSE 8080

# Tunggu MySQL siap baru jalankan Tomcat
CMD ["/usr/local/bin/wait-for-mysql.sh", "$MYSQL_HOST", "$MYSQL_PORT", "catalina.sh", "run"]
