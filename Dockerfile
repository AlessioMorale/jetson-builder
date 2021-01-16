ARG source_image
FROM $source_image
# install tzdata avoiding interactive prompts
RUN ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime && \
    apt-get update -m || true && \
    apt-get install --upgrade ca-certificates -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install gnupg2 tzdata -y && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean autoclean -y

# install the base environment and all build tools
RUN apt-get update && \
    apt-get install build-essential ninja-build cmake git python3-pip python3 python3-dev -y --no-install-recommends && \
    apt-get clean autoclean -y

# install cuda build tools
RUN apt-get install cuda-cudart-10-2 cuda-cufft-10-2 cuda-curand-10-2 cuda-cusolver-10-2 cuda-cusparse-10-2 cuda-npp-10-2 cuda-nvgraph-10-2 \ 
    cuda-nvrtc-10-2 libcublas10 libcudnn8 cuda-compiler-10-2 cuda-minimal-build-10-2 cuda-libraries-dev-10-2 libcudnn8-dev -y --no-install-recommends && \
    apt-get clean autoclean -y
