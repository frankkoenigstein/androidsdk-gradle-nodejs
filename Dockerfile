FROM openjdk:8-jdk

ARG OPTDIR="/opt"

# versions
ARG ANDROID_COMPILE_SDK="32"
ARG ANDROID_BUILD_TOOLS="32.0.0"
ARG ANDROID_COMMANDLINE_TOOLS="8512546"
ARG NODEJS_VERSION="16.15.0"
ARG GRADLE_VERSION="7.4.2"

# labels
LABEL version = "2.1.0"
LABEL description = "android-sdk@${ANDROID_COMMANDLINE_TOOLS} + gradle@${GRADLE_VERSION} + nodejs@${NODEJS_VERSION}"

# env
ENV GRADLE_HOME "${OPTDIR}/gradle-${GRADLE_VERSION}"
ENV ANDROID_SDK_ROOT "${OPTDIR}/android-sdk"
ENV PATH "$PATH:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/tools/bin:${ANDROID_SDK_ROOT}/build-tools/${ANDROID_BUILD_TOOLS}:${OPTDIR}/gradle-${GRADLE_VERSION}/bin:${OPTDIR}/node-v${NODEJS_VERSION}-linux-x64/bin"

# files
ARG DOWNLOAD_FILE_ANDROID_COMMANDLINE_TOOLS="commandlinetools-linux-${ANDROID_COMMANDLINE_TOOLS}_latest.zip"
ARG DOWNLOAD_FILE_NODE="node-v${NODEJS_VERSION}-linux-x64.tar.gz"
ARG DOWNLOAD_FILE_GRADLE="gradle-${GRADLE_VERSION}-bin.zip"

# sha256
ARG ANDROID_DOWNLOAD_SHA256="2ccbda4302db862a28ada25aa7425d99dce9462046003c1714b059b5c47970d8"
ARG NODE_DOWNLOAD_SHA256="d1c1de461be10bfd9c70ebae47330fb1b4ab0a98ad730823fb1340e34993edee"
ARG GRADLE_DOWNLOAD_SHA256="29e49b10984e585d8118b7d0bc452f944e386458df27371b49b4ac1dec4b7fda"

# download urls
ARG DOWNLOAD_URL_ANDROID_COMMANDLINE_TOOLS="https://dl.google.com/android/repository/${DOWNLOAD_FILE_ANDROID_COMMANDLINE_TOOLS}"
ARG DOWNLOAD_URL_NODE="https://nodejs.org/dist/v${NODEJS_VERSION}/${DOWNLOAD_FILE_NODE}"
ARG DOWNLOAD_URL_GRADLE="https://services.gradle.org/distributions/${DOWNLOAD_FILE_GRADLE}"

# apt
RUN apt-get --quiet update --yes \
  && apt-get upgrade --yes \
  && apt-get --quiet install --yes --no-install-recommends lib32stdc++6 lib32z1

# check and extract
RUN curl -L ${DOWNLOAD_URL_ANDROID_COMMANDLINE_TOOLS} --output ${OPTDIR}/${DOWNLOAD_FILE_ANDROID_COMMANDLINE_TOOLS} \
  && echo "${ANDROID_DOWNLOAD_SHA256} ${OPTDIR}/${DOWNLOAD_FILE_ANDROID_COMMANDLINE_TOOLS}" | sha256sum --check --status \
  && unzip -q ${OPTDIR}/${DOWNLOAD_FILE_ANDROID_COMMANDLINE_TOOLS} -d ${ANDROID_SDK_ROOT} \
  && rm ${OPTDIR}/${DOWNLOAD_FILE_ANDROID_COMMANDLINE_TOOLS} \
  && mkdir ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
  && mv ${ANDROID_SDK_ROOT}/cmdline-tools/bin ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
  && mv ${ANDROID_SDK_ROOT}/cmdline-tools/lib ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
  && mv ${ANDROID_SDK_ROOT}/cmdline-tools/NOTICE.txt ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
  && mv ${ANDROID_SDK_ROOT}/cmdline-tools/source.properties ${ANDROID_SDK_ROOT}/cmdline-tools/latest

RUN curl -L ${DOWNLOAD_URL_NODE} --output ${OPTDIR}/${DOWNLOAD_FILE_NODE} \
  && echo "${NODE_DOWNLOAD_SHA256} ${OPTDIR}/${DOWNLOAD_FILE_NODE}" | sha256sum --check --status \
  && tar xf ${OPTDIR}/${DOWNLOAD_FILE_NODE} -C ${OPTDIR} \
  && rm ${OPTDIR}/${DOWNLOAD_FILE_NODE}

RUN curl -L ${DOWNLOAD_URL_GRADLE} --output ${OPTDIR}/${DOWNLOAD_FILE_GRADLE} \
  && echo "${GRADLE_DOWNLOAD_SHA256} ${OPTDIR}/${DOWNLOAD_FILE_GRADLE}" | sha256sum --check --status \
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