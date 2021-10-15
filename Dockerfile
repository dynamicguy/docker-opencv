# syntax=docker/dockerfile:1
FROM python:3.8-slim-bullseye
LABEL "com.dynamicguy.vendor"="Dynamic Guy"
LABEL version="1.0.0"
LABEL description="Latest and greatest \
opencv and opencv_contrib built in one container."
ARG APP_HOME=/app
RUN apt-get update \
    && apt-get install -y \
        build-essential \
        cmake \
        git \
        wget \
        unzip \
        yasm \
        pkg-config \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libavformat-dev \
        libpq-dev \
        python3-numpy \
        python3-pil \
    && rm -rf /var/lib/apt/lists/*

WORKDIR ${APP_HOME}
ENV OPENCV_VERSION="4.5.3"
RUN wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip \
&& unzip ${OPENCV_VERSION}.zip \
&& rm ${OPENCV_VERSION}.zip
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
&& unzip ${OPENCV_VERSION}.zip \
&& mkdir ${APP_HOME}/opencv-${OPENCV_VERSION}/cmake_binary \
&& cd ${APP_HOME}/opencv-${OPENCV_VERSION}/cmake_binary \
&& cmake -D BUILD_TIFF=ON \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  -D OPENCV_EXTRA_MODULES_PATH=${APP_HOME}/opencv_contrib-${OPENCV_VERSION}/modules \
  -D WITH_CUDA=OFF \
  -D WITH_OPENGL=ON \
  -D WITH_OPENCL=ON \
  -D WITH_IPP=ON \
  -D WITH_TBB=ON \
  -D WITH_EIGEN=ON \
  -D WITH_V4L=ON \
  -D BUILD_TESTS=OFF \
  -D BUILD_PERF_TESTS=OFF \
  -D BUILD_opencv_legacy=OFF \
  -D BUILD_opencv_java=OFF \
  -D BUILD_opencv_python3=ON \
  -D BUILD_opencv_js=OFF \       
  -D BUILD_opencv_ximgproc=ON \
  -D BUILD_opencv_xphoto=ON \
  -D BUILD_opencv_xfeatures2d=ON \
  -D BUILD_opencv_shape=ON \
  -D BUILD_opencv_surface_matching=ON \
  -D BUILD_opencv_text=OFF \
  -D BUILD_opencv_apps=OFF \
  -D OPENCV_ENABLE_NONFREE=ON \
  -D CMAKE_BUILD_TYPE=Releases \
  -D PYTHON_EXECUTABLE=$(which python3.9) \
  -D PYTHON_INCLUDE_DIR=$(python3.9 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
  -D PYTHON_PACKAGES_PATH=$(python3.9 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
  .. \
&& make install \
&& rm ${APP_HOME}/${OPENCV_VERSION}.zip \
&& rm -r ${APP_HOME}/opencv-${OPENCV_VERSION}
