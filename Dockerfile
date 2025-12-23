# Use OpenJDK 17 as base image
FROM eclipse-temurin:17-jdk-jammy

# Set the working directory
WORKDIR /app

# Copy the application JAR file (Make sure to build your project first)
COPY target/demo_spring_with_argo.jar demo_spring_with_argo.jar

# Expose the application port
EXPOSE 9090

# Run the application
ENTRYPOINT ["java", "-jar", "demo_spring_with_argo.jar"]
