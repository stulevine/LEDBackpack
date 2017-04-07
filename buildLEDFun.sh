#!env /bin/sh
#
# Since the Raspberry Pi does not currently have a working Package Manager, we need
# to pull it all together into a compile script
#

# Build ledfun app

if [ -e "main.swift" ]
then
    rm main.swift
fi

ln -s LEDFun.swift main.swift

swiftc -v -o ledfun -I libs/SMBus-swift/Packages/Ci2c -I libs/SMBus-swift/Packages/CioctlHelper libs/SMBus-swift/Sources/SMBus.swift Signals.swift LEDBackpack.swift main.swift

rm main.swift
