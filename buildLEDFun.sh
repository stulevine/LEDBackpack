#!env /bin/sh
#
# Since the Raspberry Pi does not currently have a working Package Manager, we need
# to pull it all together into a compile script
#

# Build ledfun app
rm main.swift

ln -s LEDFun.swift main.swift

swiftc -v -o ledfun -I lib/SMBus-swift/Packages/Ci2c -I lib/SMBus-swift/Packages/CioctlHelper lib/SMBus-swift/Sources/SMBus.swift Signals.swift LEDBackpack.swift main.swift

rm main.swift
