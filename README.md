# VPay

## Clone the repo
```
git clone https://github.com/palliums-developers/vpay.git
cd vpay
```

## Build

Build for Windows and Linux on Ubuntu 18.04 and for OSX on latest OSX.
A 'Dockerfile' file is provided to build Linux and Windows binaries.

### Build static release on macOS
```
./tools/buildvpay.sh osx
```

### Build static release on Linux
```
docker run -v $PWD:/vpay doubledog/vpay:build /bin/sh -c "cd /vpay && ./tools/buildvpay.sh linux && cp /docker_bld_root/build-linux-gcc/VPay /vpay/VPay"
```

### Build static release on Linux for Windows
```
docker run -v $PWD:/vpay doubledog/vpay:build /bin/sh -c "cd /vpay && ./tools/buildvpay.sh windows && cp build-mingw-w64/release/VPay.exe /vpay/VPay.exe"
```
