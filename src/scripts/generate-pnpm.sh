#!/bin/bash
find . -name 'pnpm-lock.yaml' | sort | xargs cat | shasum | awk '{print $1}' > /tmp/pnpm_lock_seed
