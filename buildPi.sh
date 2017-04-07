#!env /bin/sh
#
# Since the Raspberry Pi does not currently have a working Package Manager, we need
# to pull it all together into a compile script
#

if [ -e "main.swift" ]
then
    rm main.swift
fi

# Build the pi app
ln -s Pi.swift main.swift

swiftc -v -o pi -I libs/SMBus-swift/Packages/Ci2c -I libs/SMBus-swift/Packages/CioctlHelper libs/SMBus-swift/Sources/SMBus.swift Signals.swift libs/SipHash/sources/*.swift libs/BigInt/sources/*.swift Coroutine.swift LEDBackpack.swift main.swift

rm main.swift
