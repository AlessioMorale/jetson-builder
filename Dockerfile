ARG source_image
FROM $source_image
ARG RELEASE r32.5

# install tzdata avoiding interactive prompts
RUN ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime && \
    apt-get update -m || true && \
    apt-get install --upgrade ca-certificates curl gnupg2 -y && \
    curl https://repo.download.nvidia.com/jetson/jetson-ota-public.asc -o /etc/jetson-ota-public.key && \
    apt-key add /etc/jetson-ota-public.key && \
    echo "deb https://repo.download.nvidia.com/jetson/common $RELEASE main" >> /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install gnupg2 tzdata -y && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean autoclean -y && \
    rm -rf /var/lib/apt/lists/*

# install the base environment and all build tools
RUN apt-get update && \
    apt-get install build-essential ninja-build cmake git python3 python3-dev python3-pip -y --no-install-recommends && \
    apt-get clean autoclean -y

ARG CUDA_VERSION=10-2
# install cuda & build tools
RUN apt-get install cuda-libraries-${CUDA_VERSION} cuda-libraries-dev-${CUDA_VERSION} cuda-nvtx-${CUDA_VERSION} cuda-minimal-build-${CUDA_VERSION} \
    cuda-command-line-tools-${CUDA_VERSION} cuda-cudart-${CUDA_VERSION} cuda-cufft-${CUDA_VERSION} cuda-curand-${CUDA_VERSION} \
    cuda-cusolver-${CUDA_VERSION} cuda-cusparse-${CUDA_VERSION} cuda-npp-${CUDA_VERSION} cuda-nvgraph-${CUDA_VERSION} \ 
    cuda-nvrtc-${CUDA_VERSION} libcublas10 libcudnn8 libcudnn8-dev -y --no-install-recommends && \
    apt-get clean autoclean -y

SHELL ["/bin/bash", "-c"]
COPY ./buildfiles/* /root/
env CACHE_GIT_URL=dummy
RUN apt-get update && \
    apt-get install -y ccache --no-install-recommends && \
    apt-get clean autoclean -y && \
    source /root/setup_ccache && \
    upgrade_ccache
