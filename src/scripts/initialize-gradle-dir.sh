#!/bin/bash

#

# Gradle tests
mkdir -p ~/.gradle && cp gradle/init-with-moved-buildDir.gradle ~/.gradle/init.gradle

# generate gradle cache seed
find . -name 'build.gradle.kts' | sort | xargs cat | shasum | awk '{print $1}' > /tmp/gradle_cache_seed

# restore gradle_cache_seed
gradle-v1-{{ checksum "/tmp/gradle_cache_seed" }}-{{ checksum ".circleci/config.yml" }}

