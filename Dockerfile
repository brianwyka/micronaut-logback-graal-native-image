FROM oracle/graalvm-ce:20.1.0-java8 as graalvm
RUN gu install native-image

COPY . /home/app/micronaut-logback-native-image
WORKDIR /home/app/micronaut-logback-native-image

RUN native-image --no-server --no-fallback --static -cp target/micronaut-logback-native-image-*.jar

FROM frolvlad/alpine-glibc
RUN apk update && apk add libstdc++
EXPOSE 8080
COPY --from=graalvm /home/app/micronaut-logback-native-image/micronaut-logback-native-image /app/micronaut-logback-native-image
ENTRYPOINT ["/app/micronaut-logback-native-image"]
