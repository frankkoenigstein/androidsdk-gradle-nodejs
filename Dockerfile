FROM openjdk:8-jdk

ARG OPTDIR="/opt"

# versions
ARG ANDROID_COMPILE_SDK="30"
ARG ANDROID_BUILD_TOOLS="30.0.3"
ARG ANDROID_SDK_TOOLS="7583922"
ARG NODEJS_VERSION="14.18.1"
ARG GRADLE_VERSION="7.2"

# labels
LABEL version = "2.0.0"
LABEL description = "android-sdk@${ANDROID_SDK_TOOLS} + gradle@${GRADLE_VERSION} + nodejs@${NODEJS_VERSION}"

# env
ENV GRADLE_HOME "${OPTDIR}/gradle-${GRADLE_VERSION}"
ENV ANDROID_SDK_ROOT "${OPTDIR}/android-sdk"
ENV PATH "$PATH:${ANDROID_SDK_ROOT}/cmdline-tools/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/tools/bin:${ANDROID_SDK_ROOT}/build-tools/${ANDROID_BUILD_TOOLS}:${OPTDIR}/gradle-${GRADLE_VERSION}/bin:${OPTDIR}/node-v${NODEJS_VERSION}-linux-x64/bin"

# files
ARG DOWNLOAD_FILE_ANDROID_SDK_TOOLS="commandlinetools-linux-${ANDROID_SDK_TOOLS}_latest.zip"
ARG DOWNLOAD_FILE_NODE="node-v${NODEJS_VERSION}-linux-x64.tar.gz"
ARG DOWNLOAD_FILE_GRADLE="gradle-${GRADLE_VERSION}-bin.zip"

# sha256
ARG ANDROID_DOWNLOAD_SHA256="124f2d5115eee365df6cf3228ffbca6fc3911d16f8025bebd5b1c6e2fcfa7faf"
ARG NODE_DOWNLOAD_SHA256="088498c67bab31871a1cab40dbc9b7b82c1abf53a2cf740e061bd6033a74839d"
ARG GRADLE_DOWNLOAD_SHA256="f581709a9c35e9cb92e16f585d2c4bc99b2b1a5f85d2badbd3dc6bff59e1e6dd"

# download urls
ARG DOWNLOAD_URL_ANDROID_SDK_TOOLS="https://dl.google.com/android/repository/${DOWNLOAD_FILE_ANDROID_SDK_TOOLS}"
ARG DOWNLOAD_URL_NODE="https://nodejs.org/dist/v${NODEJS_VERSION}/${DOWNLOAD_FILE_NODE}"
ARG DOWNLOAD_URL_GRADLE="https://services.gradle.org/distributions/${DOWNLOAD_FILE_GRADLE}"

# apt
RUN apt-get --quiet update --yes \
  && apt-get --quiet install --yes --no-install-recommends lib32stdc++6 lib32z1

# download
RUN curl -L ${DOWNLOAD_URL_ANDROID_SDK_TOOLS} --output ${OPTDIR}/${DOWNLOAD_FILE_ANDROID_SDK_TOOLS}
RUN curl -L ${DOWNLOAD_URL_NODE} --output ${OPTDIR}/${DOWNLOAD_FILE_NODE}
RUN curl -L ${DOWNLOAD_URL_GRADLE} --output ${OPTDIR}/${DOWNLOAD_FILE_GRADLE}

# check and extract
RUN echo "${ANDROID_DOWNLOAD_SHA256} ${OPTDIR}/${DOWNLOAD_FILE_ANDROID_SDK_TOOLS}" | sha256sum --check --status \
  && unzip -q ${OPTDIR}/${DOWNLOAD_FILE_ANDROID_SDK_TOOLS} -d ${ANDROID_SDK_ROOT} \
  && rm ${OPTDIR}/${DOWNLOAD_FILE_ANDROID_SDK_TOOLS}

RUN echo "${NODE_DOWNLOAD_SHA256} ${OPTDIR}/${DOWNLOAD_FILE_NODE}" | sha256sum --check --status \
  && tar xf ${OPTDIR}/${DOWNLOAD_FILE_NODE} -C ${OPTDIR} \
  && rm ${OPTDIR}/${DOWNLOAD_FILE_NODE}

RUN echo "${GRADLE_DOWNLOAD_SHA256} ${OPTDIR}/${DOWNLOAD_FILE_GRADLE}" | sha256sum --check --status \
  && unzip -q ${OPTDIR}/${DOWNLOAD_FILE_GRADLE} -d ${OPTDIR} \
  && rm ${OPTDIR}/${DOWNLOAD_FILE_GRADLE}

# install android tools and platform
RUN echo y | sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platforms;android-${ANDROID_COMPILE_SDK}" > /dev/null
RUN echo y | sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platform-tools" > /dev/null
RUN echo y | sdkmanager --sdk_root=$ANDROID_SDK_ROOT "build-tools;${ANDROID_BUILD_TOOLS}" > /dev/null

RUN yes | sdkmanager --sdk_root=$ANDROID_SDK_ROOT --licenses > /dev/null

# apt clean
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get clean