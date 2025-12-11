# ====== Stage 1: Build ứng dụng ======
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

# Build jar, bỏ qua test cho nhanh
RUN mvn -B -DskipTests clean package

# ====== Stage 2: Runtime image ======
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copy file jar đã build sang
COPY --from=build /app/target/AssignmentCSDL-0.0.1-SNAPSHOT.jar app.jar

# Đảm bảo JVM dùng UTF-8 (tiếng Việt không lỗi font)
ENV JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"

EXPOSE 8082

ENTRYPOINT ["java", "-jar", "app.jar"]
