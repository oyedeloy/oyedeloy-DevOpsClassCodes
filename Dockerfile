# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variable for the War file (replace with your actual War file name)
ENV WAR_FILE=addressbook.war
# Copy your War file into the container
COPY $WAR_FILE /app/

# Expose the port your application will run on (if necessary)
EXPOSE 8080

# Start your application (adjust the command as needed)
CMD ["java", "-jar", "/app/$WAR_FILE"]