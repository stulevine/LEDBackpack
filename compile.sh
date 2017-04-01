#!env /bin/sh
#
# Since the Raspberry Pi does not currently have a working Package Manager, we need
# to pull it all together into a compile script
#
swiftc -v -o ledfun -I SMBus-swift/Packages/Ci2c -I SMBus-swift/Packages/CioctlHelper SMBus-swift/Sources/SMBus.swift LEDBackpack.swift main.swift
