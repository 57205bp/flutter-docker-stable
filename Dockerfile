# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set non-interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Environment variables
ENV ANDROID_HOME=/usr/lib/android-sdk
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
ENV FLUTTER_HOME=/flutter
ENV JAVA_VERSION="17"
ENV ANDROID_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip"
ENV ANDROID_VERSION="29"
ENV ANDROID_BUILD_TOOLS_VERSION="29.0.3"
ENV FLUTTER_CHANNEL="stable"
ENV FLUTTER_VERSION="3.27.0"
ENV GRADLE_VERSION="7.2"
ENV GRADLE_USER_HOME="/opt/gradle"
ENV GRADLE_URL="https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip"
ENV FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/$FLUTTER_CHANNEL/linux/flutter_linux_$FLUTTER_VERSION-$FLUTTER_CHANNEL.tar.xz"
ENV FLUTTER_ROOT="/opt/flutter"
ENV PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/platforms:$FLUTTER_ROOT/bin:$GRADLE_USER_HOME/bin:$PATH:$FLUTTER_HOME/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    gpg \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-$JAVA_VERSION-jdk \
    x11-apps \
    cmake \
    clang \
    pkg-config \
    libgtk-3-dev \
    ninja-build \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils \
    libqt5widgets5 \
    libqt5gui5 \
    libqt5core5a \
    libgl1-mesa-glx \
    libqt5x11extras5 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-render0 \
    libxcb-shape0 \
    libxcb-sync1 \
    libxcb-xfixes0 \
    libxcb-xinerama0 \
    libxkbcommon-x11-0 \
    libxkbcommon0 \
    libpulse0 \
    libxcomposite1 \
    ssh \
    xauth \
    x11-xserver-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Gradle
RUN curl -L $GRADLE_URL -o gradle-$GRADLE_VERSION-bin.zip \
    && unzip gradle-$GRADLE_VERSION-bin.zip \
    && mv gradle-$GRADLE_VERSION $GRADLE_USER_HOME \
    && rm gradle-$GRADLE_VERSION-bin.zip

# Install Google Chrome
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y google-chrome-stable        

# Install Flutter SDK
RUN curl -o flutter.tar.xz $FLUTTER_URL \
    && mkdir -p $FLUTTER_ROOT \
    && tar xf flutter.tar.xz -C /opt/ \
    && rm flutter.tar.xz \
    && git config --global --add safe.directory /opt/flutter \
    && flutter config --no-analytics \
    && flutter precache \
    && yes "y" | flutter doctor --android-licenses \
    && flutter doctor \
    && flutter update-packages

# Install Android SDK
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd ${ANDROID_HOME}/cmdline-tools && \
    curl -o cmdline-tools.zip $ANDROID_TOOLS_URL && \
    unzip cmdline-tools.zip && \
    rm cmdline-tools.zip && \
    mv cmdline-tools latest && \
    yes "y" | sdkmanager --licenses && \
    yes "y" | sdkmanager "platform-tools" "platforms;android-$ANDROID_VERSION" "build-tools;$ANDROID_BUILD_TOOLS_VERSION" "emulator"

# Config Check
RUN flutter doctor

# Set the work directory
WORKDIR /app

# Expose the necessary port numbers
EXPOSE 8080 44300
