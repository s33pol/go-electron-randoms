# Go + QPID Electron; Debian builder for VSCode
FROM s33pol/qpid-proton:0.32.0 AS qpid-proton
FROM golang AS builder

# Apache QPID Proton
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y \
    libnss3 libboost-program-options1.67.0 libsasl2-2 libaio1 libdb5.3 libdb5.3++ \
    && rm -rf /var/lib/apt/lists/*
COPY --from=qpid-proton /opt/qpid-cpp /opt/qpid-cpp
COPY --from=qpid-proton /opt/qpid-proton /opt/qpid-proton
# Go QPID Electron
ENV CGO_CFLAGS "-I /opt/qpid-proton/include"
ENV CGO_LDFLAGS "-L /opt/qpid-proton/lib"
RUN GO111MODULE=on go get -x github.com/apache/qpid-proton

# Build of the Go Module
RUN mkdir -p /workspace-build
WORKDIR /workspace
COPY . .
ENV GOBIN=/workspace-build
RUN go test -v -cover ./...\
    && go install ./...

# App
FROM s33pol/qpid-proton:0.32.0
ENV PATH=/opt/electron-randoms
COPY --from=builder /workspace-build/* /opt/electron-randoms/