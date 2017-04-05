#!env /bin/sh
#
# Since the Raspberry Pi does not currently have a working Package Manager, we need
# to pull it all together into a compile script
#
rm main.swift
# Build the pi app
ln -s Pi.swift main.swift

swiftc -v -o pi -I lib/SMBus-swift/Packages/Ci2c -I lib/SMBus-swift/Packages/CioctlHelper lib/SMBus-swift/Sources/SMBus.swift Signals.swift lib/SipHash/sources/*.swift lib/BigInt/sources/*.swift Coroutine.swift LEDBackpack.swift main.swift

rm main.swift
