# syntax=docker/dockerfile:1
# lean-uprove: multi-stage build with Lake cache mount support

ARG LEAN_UPROVE_VERSION=0.2.0

FROM leanprover/lean4:v4.31.0 AS builder
WORKDIR /app
COPY . .

RUN --mount=type=cache,target=/root/.cache/lean \
    --mount=type=cache,target=/app/.lake/cache \
    lake update && lake build

FROM leanprover/lean4:v4.31.0 AS production
ARG LEAN_UPROVE_VERSION=0.2.0
ENV LEAN_UPROVE_VERSION=${LEAN_UPROVE_VERSION}
WORKDIR /app

COPY --from=builder /app/.lake /app/.lake
COPY --from=builder /app/lakefile.lean /app/lakefile.lean
COPY --from=builder /app/lake-manifest.json /app/lake-manifest.json
COPY --from=builder /app/lean-toolchain /app/lean-toolchain
COPY --from=builder /app/Uprove /app/Uprove
COPY --from=builder /app/Uprove.lean /app/Uprove.lean
COPY --from=builder /app/UproveRegisterInit.lean /app/UproveRegisterInit.lean
COPY --from=builder /app/TestRegisterInit.lean /app/TestRegisterInit.lean
COPY --from=builder /app/UproveComparisonExamples.lean /app/UproveComparisonExamples.lean
COPY --from=builder /app/examples /app/examples
COPY --from=builder /app/Test.lean /app/Test.lean
COPY --from=builder /app/bench /app/bench
COPY scripts/container-entrypoint.sh /usr/local/bin/lean-uprove
RUN chmod +x /usr/local/bin/lean-uprove

ENTRYPOINT ["/usr/local/bin/lean-uprove"]
CMD ["--help"]

LABEL org.opencontainers.image.title="lean-uprove"
LABEL org.opencontainers.image.description="A Lean 4 tactic for automating proofs involving universal properties in category theory"
LABEL org.opencontainers.image.version="${LEAN_UPROVE_VERSION}"
LABEL org.opencontainers.image.authors="fraware"
LABEL org.opencontainers.image.url="https://github.com/fraware/lean-uprove"
LABEL org.opencontainers.image.source="https://github.com/fraware/lean-uprove"
LABEL org.opencontainers.image.licenses="MIT"
