FROM registry.access.redhat.com/ubi9 AS ubi-micro-build
# Install curl for health check
RUN mkdir -p /mnt/rootfs && dnf install --installroot /mnt/rootfs curl --releasever 9 --setopt install_weak_deps=false --nodocs -y; dnf --installroot /mnt/rootfs clean all

FROM quay.io/keycloak/keycloak:22.0.1 as builder
COPY --from=ubi-micro-build /mnt/rootfs /
COPY ./providers /opt/keycloak/providers/
ENV KC_CACHE_CONFIG_FILE=cache-ispn-jdbc-ping.xml
COPY ./cache-ispn-jdbc-ping.xml /opt/keycloak/conf/cache-ispn-jdbc-ping.xml
RUN /opt/keycloak/bin/kc.sh build --cache-ispn

FROM builder as final
COPY --from=builder /opt/keycloak/ /opt/keycloak/

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]