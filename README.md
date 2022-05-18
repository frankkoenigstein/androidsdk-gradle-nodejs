# frooooonk/androidsdk-gradle-nodejs

<details>
<summary>Table of content</summary>
<!-- vscode-markdown-toc -->

- [Changelog](#Changelog)
  - [2.1.0](#2.1.0)
  - [2.0.2](#2.0.2)
  - [v2.0.0](#v2.0.0)
  - [v1.0.0](#v1.0.0)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->
</details>

Combines android sdk gradle and nodejs.
Based on [openjdk:8-jdk].

## Changelog

### v2.1.0

```dockerfile
ARG ANDROID_COMPILE_SDK="32"
ARG ANDROID_BUILD_TOOLS="32.0.0"
ARG ANDROID_COMMANDLINE_TOOLS="8512546"
ARG NODEJS_VERSION="16.15.0"
ARG GRADLE_VERSION="7.4.2"
```

### v2.0.2

```dockerfile
ARG ANDROID_COMPILE_SDK="30"
ARG ANDROID_BUILD_TOOLS="30.0.3"
ARG ANDROID_SDK_TOOLS="7583922"
ARG NODEJS_VERSION="14.18.1"
ARG GRADLE_VERSION="7.2"
```

### v2.0.0

```dockerfile
ARG ANDROID_COMPILE_SDK="31"
ARG ANDROID_BUILD_TOOLS="31.0.0"
ARG ANDROID_SDK_TOOLS="7583922"
ARG NODEJS_VERSION="14.18.1"
ARG GRADLE_VERSION="7.2"
```

### v1.0.0

```dockerfile
ARG ANDROID_COMPILE_SDK="28"
ARG ANDROID_BUILD_TOOLS="29.0.2"
ARG ANDROID_SDK_TOOLS="4333796"
ARG NODEJS_VERSION="12.16.1"
ARG GRADLE_VERSION="6.2"
```

[openjdk:8-jdk]: https://hub.docker.com/_/openjdk/?tab=tags&page=1&name=8-jdk
