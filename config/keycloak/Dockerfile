FROM registry.access.redhat.com/ubi9 AS ubi-micro-build
RUN mkdir -p /mnt/rootfs
# Install curl for health check
RUN dnf install --installroot /mnt/rootfs curl --releasever 9 --setopt install_weak_deps=false --nodocs -y; dnf --installroot /mnt/rootfs clean all

FROM quay.io/keycloak/keycloak:22.0.1 as builder
COPY --from=ubi-micro-build /mnt/rootfs /
# add
COPY ./providers /opt/keycloak/providers/
RUN /opt/keycloak/bin/kc.sh build

FROM builder as final
COPY --from=builder /opt/keycloak/ /opt/keycloak/

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]