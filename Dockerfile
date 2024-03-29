#FROM amazoncorretto:17 as builder
#MAINTAINER Vibin Krishnan
#WORKDIR application
#ARG JAR_FILE=target/*.jar
#COPY ${JAR_FILE} application.jar
#RUN java -Djarmode=layertools -jar application.jar extract
# the second stage of our build will copy the extracted layers
#FROM amazoncorretto:17
#EXPOSE 8057
#WORKDIR application
#COPY --from=builder application/dependencies/ ./
#COPY --from=builder application/spring-boot-loader/ ./
#COPY --from=builder application/snapshot-dependencies/ ./
#COPY --from=builder application/application/ ./
#ENTRYPOINT ["java", "-XX:+AlwaysPreTouch","-Xms756m", "-Xmx1g", "-XX:CompileThreshold=100", "org.springframework.boot.loader.launch.JarLauncher"]


## Building Jar & creating image

FROM amazoncorretto:17 as builder
MAINTAINER Vibin Krishnan
WORKDIR application
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src
#For removing windows based line endings in mvnw file
RUN sed -i -e 's/\r$//' ./mvnw
RUN ./mvnw package
ARG JAR_FILE=target/*.jar
RUN cp ${JAR_FILE} application.jar
RUN java -Djarmode=layertools -jar application.jar extract

# the second stage of our build will copy the extracted layers
FROM amazoncorretto:17
EXPOSE 8057
WORKDIR application
COPY --from=builder application/dependencies/ ./
COPY --from=builder application/spring-boot-loader/ ./
COPY --from=builder application/snapshot-dependencies/ ./
COPY --from=builder application/application/ ./
ENTRYPOINT ["java", "-XX:+AlwaysPreTouch","-Xms756m", "-Xmx1g", "-XX:CompileThreshold=100", "org.springframework.boot.loader.launch.JarLauncher"]




