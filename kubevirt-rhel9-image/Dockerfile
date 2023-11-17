FROM public.ecr.aws/docker/library/alpine:3.18 as builder
ADD --chown=107:107 rhel-*.qcow2 /disk/
RUN chmod 0440 /disk/*

FROM scratch
COPY --from=builder /disk/* /disk/
