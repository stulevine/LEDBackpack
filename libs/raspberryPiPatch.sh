#!env /bin/sh

cd BigInt

patch sources/BigInt.swift ../BigInt.patch
patch sources/BigUInt\ Hashing.swift ../BigUIntHashing.patch
