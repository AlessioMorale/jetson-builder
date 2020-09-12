FROM mdegans/tegra-opencv:jp-r32.4.2-cv-4.3.0

# install tzdata avoiding interactive prompts
RUN ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime && \
    apt-get update && \
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

# install opencv-python
RUN pip3 --no-cache-dir install scikit-build
RUN export CMAKE_ARGS="-DOPENCV_ENABLE_NONFREE=ON" && pip3 --no-cache-dir install "opencv-python>=4.3,<4.4" --install-option="-j8" -v
