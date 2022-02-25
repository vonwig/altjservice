FROM clojure:lein AS builder

# ARG MVN_ARTIFACTORYMAVENREPOSITORY_USER
# ARG MVN_ARTIFACTORYMAVENREPOSITORY_PWD

RUN mkdir /build

WORKDIR /build

COPY project.clj /build
COPY src /build/src

RUN lein metajar

FROM openjdk:11-jre-slim

MAINTAINER Jim Clark <jim@atomist.com>

# ARG SOURCE
# ARG REVISION
# LABEL org.opencontainers.image.revision=$REVISION
# LABEL org.opencontainers.image.source=$SOURCE

RUN mkdir -p /usr/src/app \
    && mkdir -p /usr/src/app/bin \
    && mkdir -p /usr/src/app/lib

WORKDIR /usr/src/app

COPY --from=builder /build/target/lib /usr/src/app/lib

COPY --from=builder /build/target/metajar/service.jar /usr/src/app/

CMD ["java","-Djava.net.preferIPv4Stack=true", "-jar", "/usr/src/app/service.jar", "-Dclojure.core.async.pool-size=20"]

ENV APP_NAME=service

EXPOSE 3000
