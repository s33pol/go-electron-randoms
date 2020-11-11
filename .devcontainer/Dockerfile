# Go + QPID Electron; Debian builder for VSCode
FROM s33pol/qpid-proton:0.32.0 AS qpid-proton
FROM s33pol/golang-vscode

# Apache QPID Proton
ENV DEBIAN_FRONTEND=noninteractive
RUN sudo apt-get update \
    && sudo apt-get install -y \
    libnss3 libboost-program-options1.67.0 libsasl2-2 libaio1 libdb5.3 libdb5.3++ \
    && sudo rm -rf /var/lib/apt/lists/*
ENV LD_LIBRARY_PATH "$LD_LIBRARY_PATH:/opt/qpid-proton/lib"
COPY --from=qpid-proton /opt/qpid-cpp /opt/qpid-cpp
COPY --from=qpid-proton /opt/qpid-proton /opt/qpid-proton
# Go QPID Electron
ENV CGO_CFLAGS "-I /opt/qpid-proton/include"
ENV CGO_LDFLAGS "-L /opt/qpid-proton/lib"
RUN GO111MODULE=on go get -x github.com/apache/qpid-proton