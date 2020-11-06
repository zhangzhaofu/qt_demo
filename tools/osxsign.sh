#!/bin/bash
set -eo pipefail

. tools/envs.env osx

codesign --options runtime --entitlements entitlements.plist --deep ./build-osx-clang/VPay.app -s "Developer ID Application: Zhaofu Zhang (39U6RN7SJ5)"
