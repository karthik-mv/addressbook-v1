#Stage 1
From maven:3.8.4-openjdk-11-slim AS buildstage

#set the working directory inside the container
WORKDIR /app

#Copy the maven project definition files
COPY pom.xml ./

#dowmload the dependencies needed for thr build (cache in the seperate layer)

RUN mvn dependency:go-offline

#copy the application source code
COPY src ./src

#build the warfile

RUN mvn package


#Stage 2: production stage

From tomcat:8.5.78-jdk11-openjdk-slim

#copy the built war file from the build stage to the tomcat webapps directory

COPY --from=buildstage /app/target/*.war /usr/local/tomcat/webapps/


#Expose the port

EXPOSE 8080

#start tomcat

CMD ["catalina.sh", "run"]
