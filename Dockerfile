### docker build --pull -t rhel-atomic-tools .
FROM registry.access.redhat.com/rhel-atomic
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

### Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="rhel-atomic-tools" \
      version="1" \
      release="1"

ENV S2I_VERSION=v1.1.6 \
    GIT_COMMIT=f519129

RUN microdnf --enablerepo=rhel-7-server-rpms --enablerepo=rhel-7-server-optional-rpms \
    install --nodocs tar gzip && \
    microdnf clean all

RUN curl -o /tmp/s2i.tar.gz -SL \
      https://github.com/openshift/source-to-image/releases/download/${S2I_VERSION}/source-to-image-${S2I_VERSION}-${GIT_COMMIT}-linux-amd64.tar.gz \
      --retry 9 --retry-max-time 0 -C - && \
    tar xvfz /tmp/s2i.tar.gz -C /usr/bin && \
    rm -f /tmp/s2i.tar.gz && \
    chmod +x /usr/bin/s2i

# USER ${USER_UID}
# WORKDIR ${APP_ROOT}