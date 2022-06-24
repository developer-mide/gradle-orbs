#!/bin/bash

find . -name 'build.gradle.kts' | sort | xargs cat | shasum | awk '{print $1}' > /tmp/gradle_cache_seed