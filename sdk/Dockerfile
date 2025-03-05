# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set non-interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Environment variables
ENV ANDROID_HOME=/usr/lib/android-sdk
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
ENV JAVA_VERSION="17"
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PATH"

# Set ARG for Flutter version (default: stable)
ARG FLUTTER_VERSION=stable
ENV FLUTTER_VERSION=$FLUTTER_VERSION

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
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils \
    ssh \
    xauth \
    x11-xserver-utils \
    libgtk-3-dev \
    libimobiledevice6 \
    ideviceinstaller \
    usbmuxd \
    libusbmuxd-tools \
    ninja-build \
    wget \
    sudo \
    bash \
    mingw-w64 \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y google-chrome-stable

# Clone and install Flutter SDK from GitHub
RUN git clone --depth 1 --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git $FLUTTER_HOME \
    && git config --global --add safe.directory $FLUTTER_HOME \
    && cd $FLUTTER_HOME && rm engine/src/.gn \
    && $FLUTTER_HOME/bin/flutter config --no-analytics \
    && $FLUTTER_HOME/bin/flutter precache --android --ios --web --linux --windows \
    && yes "y" | $FLUTTER_HOME/bin/flutter doctor --android-licenses \
    && $FLUTTER_HOME/bin/flutter doctor \
    && chown -R root:root $FLUTTER_HOME

# Install Android SDK & required tools
RUN mkdir -p $ANDROID_HOME/cmdline-tools \
    && curl -fsSL https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -o cmdline-tools.zip \
    && unzip cmdline-tools.zip -d $ANDROID_HOME/cmdline-tools \
    && rm cmdline-tools.zip \
    && mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest \
    && yes | sdkmanager --licenses \
    && sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" "cmdline-tools;latest" "ndk;26.1.10909125"

# Enable Android, iOS, Web, Linux, and Windows support in Flutter
RUN flutter config --enable-web \
    && flutter config --enable-linux-desktop \
    && flutter config --enable-android \
    && flutter config --enable-ios \
    && flutter config --enable-windows-desktop

# Accept Android licenses
RUN yes | flutter doctor --android-licenses

# Set the work directory
WORKDIR /app

# Expose the necessary port numbers
EXPOSE 8080 44300 5353

# Verify installation
RUN flutter doctor

# Default command
CMD ["bash"]
