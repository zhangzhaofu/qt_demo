#!/bin/bash
set -eo pipefail

app_name=VPay.app
zip_name=VPayQt_MacOSX_x86_64.zip

zip -r ${zip_name} ${app_name}

xcrun altool --notarize-app \
               --username "${STAPLEEMAIL}" \
               --primary-bundle-id com.zhangzhoafu.VPay \
               --password "${STAPLEPW}" \
               --file ${zip_name}

while :
do
  sleep 10
  xcrun altool --notarization-history 0 -u "${STAPLEEMAIL}" -p "${STAPLEPW}" | fgrep "in progress" || break
done

xcrun stapler staple ${app_name}

zip -r ${zip_name} ${app_name}
