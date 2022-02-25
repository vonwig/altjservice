FROM clojure:lein@sha256:9c193148b801e0bdc8aca9940b363d35a9d0927c3c1b3aa53aa96e477d44b134 AS builder

# ARG MVN_ARTIFACTORYMAVENREPOSITORY_USER
# ARG MVN_ARTIFACTORYMAVENREPOSITORY_PWD

RUN mkdir /build

WORKDIR /build

COPY project.clj /build
COPY src /build/src

RUN lein metajar

FROM openjdk:11-jre-slim@sha256:d6eff0a017d72b59c0c865488ac39fa1dedd5ad6526a35f27b7bf7a3e3ae9f67

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
