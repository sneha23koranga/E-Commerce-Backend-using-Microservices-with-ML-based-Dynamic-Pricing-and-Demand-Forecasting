# ---------- Stage 1: build the jar ----------
FROM maven:3.9-eclipse-temurin-21 AS build
ARG SERVICE
WORKDIR /workspace
COPY . .
RUN --mount=type=cache,target=/root/.m2,sharing=locked mvn -B -pl ${SERVICE} -am clean package -DskipTests
RUN cp ${SERVICE}/target/*.jar /workspace/app.jar

# ---------- Stage 2: run it ----------
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /workspace/app.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]