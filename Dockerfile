FROM openjdk:8-jdk

ARG OPTDIR="/opt"

# versions
ARG ANDROID_COMPILE_SDK="28"
ARG ANDROID_BUILD_TOOLS="29.0.2"
ARG ANDROID_SDK_TOOLS="4333796"
ARG NODEJS_VERSION="12.16.1"
ARG GRADLE_VERSION="6.2"

# labels
LABEL version = "1.0.0"
LABEL description = "android-sdk@${ANDROID_SDK_TOOLS} + gradle@${GRADLE_VERSION} + nodejs@${NODEJS_VERSION}"

# env
ENV GRADLE_HOME "${OPTDIR}/gradle-${GRADLE_VERSION}"
ENV ANDROID_SDK_ROOT "${OPTDIR}/android-sdk"
ENV PATH "$PATH:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/tools/bin:${ANDROID_SDK_ROOT}/build-tools/${ANDROID_BUILD_TOOLS}:${OPTDIR}/gradle-${GRADLE_VERSION}/bin:${OPTDIR}/node-v${NODEJS_VERSION}-linux-x64/bin"

# files
ARG DOWNLOAD_FILE_ANDROID_SDK_TOOLS="sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip"
ARG DOWNLOAD_FILE_NODE="node-v${NODEJS_VERSION}-linux-x64.tar.gz"
ARG DOWNLOAD_FILE_GRADLE="gradle-${GRADLE_VERSION}-bin.zip"

# sha256
ARG ANDROID_DOWNLOAD_SHA256="92ffee5a1d98d856634e8b71132e8a95d96c83a63fde1099be3d86df3106def9"
ARG NODE_DOWNLOAD_SHA256="b2d9787da97d6c0d5cbf24c69fdbbf376b19089f921432c5a61aa323bc070bea"
ARG GRADLE_DOWNLOAD_SHA256="b93a5f30d01195ec201e240f029c8b42d59c24086b8d1864112c83558e23cf8a"

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
RUN echo y | sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" > /dev/null
RUN echo y | sdkmanager "platform-tools" > /dev/null
RUN echo y | sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" > /dev/null

RUN yes | sdkmanager --licenses > /dev/null

# apt clean
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get clean