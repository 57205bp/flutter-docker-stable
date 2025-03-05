FROM ubuntu:22.04


LABEL org.opencontainers.image.source=https://github.com/your-repo/flutter-docker

# Install required dependencies
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    wget unzip curl git && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator"

# Install Android SDK
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && cd ${ANDROID_HOME}/cmdline-tools && \
    curl -o sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip sdk-tools.zip -d latest && rm sdk-tools.zip && \
    yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2"

# Install Flutter
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${PATH}:${FLUTTER_HOME}/bin"
RUN git clone --depth 1 --branch stable https://github.com/flutter/flutter.git ${FLUTTER_HOME} && \
    flutter config --no-analytics && \
    flutter precache

WORKDIR /workspace
CMD ["bash"]