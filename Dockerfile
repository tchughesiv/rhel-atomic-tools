### docker build --pull -t rhel-atomic-tools .
FROM registry.access.redhat.com/rhel-atomic
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

### Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="rhel-atomic-tools" \
      version="1" \
      release="1"

RUN microdnf --enablerepo=rhel-7-server-rpms --enablerepo=rhel-7-server-optional-rpms \
    install --nodocs git tar && \
    microdnf clean all

ENV APP_ROOT=/opt/app-root \
    USER_NAME=default \
    USER_UID=10001 \
    S2I_VERSION=v1.1.6

ENV APP_HOME=${APP_ROOT}/src  PATH=$PATH:${APP_ROOT}/bin
RUN mkdir -p ${APP_HOME} ${APP_ROOT}/bin
# COPY bin/ ${APP_ROOT}/bin/

RUN curl -o ${APP_ROOT}/s2i.tar.gz -SL https://github.com/openshift/source-to-image/archive/${S2I_VERSION}.tar.gz \
      --retry 9 --retry-max-time 0 -C - && \
    chmod -R ug+x ${APP_ROOT}/bin /tmp/user_setup && \
    /tmp/user_setup

# USER ${USER_UID}
# WORKDIR ${APP_ROOT}