# Use an official Java runtime as a parent image
FROM openjdk:11-jre-alpine

# Set the working directory
WORKDIR /app

# Copy the application JAR file into the container
COPY target/DevOps_Project-1.0.jar DevOps_Project-1.0.jar

# Specify the command to run when the container starts
CMD ["java", "-jar", "DevOps_Project-1.0.jar"]