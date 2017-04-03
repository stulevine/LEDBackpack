//
//  LEDBackpack.swift
//  
//
//  Created by Stuart Levine on 3/31/17.
//
//

import Foundation

/**
 * @brief This Swift class is a driver for the Adafruit Bicolor LED Square Pixel Matrix with I2C Backpack
 *        https://www.adafruit.com/products/902
 *        It requires the SMBus-swift library written by Fabio Ritrovato available on Github: 
 *        https://github.com/Sephiroth87/SMBus-swift
 *        Based on the Raspberry Pi Python Adafruit LEDBackpack and 8x8 driver sources
 */
public class LEDBackpack {
    public enum GridColor: Int {
        case off = 0
        case red = 1
        case green = 2
        case orange = 3
    }

    // Registers
    static private let registerDisplaySetup: UInt8 = 0x80
    static private let registerSystemSetup: UInt8 = 0x20
    static private let registerDimming: UInt8 = 0xE0
    static private let registerSetMode: UInt8 = 0x00
    static private let registerSetState: UInt8 = 0x01
    // Blink rate
    public enum BlinkRate: UInt8 {
        case off     = 0x00
        case r2HZ    = 0x01
        case r1HZ    = 0x02
        case rHalfHZ = 0x03
    }
    
    private let bus: SMBus
    private var buffer = [UInt16](repeating: 0x0000, count: 8)
    private var gridRows = 8
    private var i2cAddress: Int32 = 0x70
    /**
     * @brief - Initializer returns the LEDBackpack driver
     *
     * @param busNumber: Int    - indicates which I2C bus to use.  Default is 1
     * @param i2cAddress: Int32 - the I2C address of the LEDBackpack (on RPi use i2cdetect -y 1 to reveal this address)
     *                            Default is 0x70 on Raspberry Pi
     * @param brightness: UInt8 - sets the LED brightness for all pixels.  Value range is 0-15
     * @param blinkRate: enum   - sets the LED blinkRate based on the blinkRate enum
     * @param gridRows: Int?    - Allows for expanded grids other than the default of 8x8
     *
     * @return LEDBackpack instance
     *
     */
    public init(busNumber: Int = 1,
                i2cAddress: Int32 = 0x70,
                brightness: UInt8 = 5,
                blinkRate: BlinkRate = .off,
                gridRows: Int? = nil) throws {
        
        self.i2cAddress = i2cAddress
        try bus = SMBus(busNumber: busNumber)
        try bus.writeI2CBlockData(address: i2cAddress, command: LEDBackpack.registerSystemSetup | 0x01, values: [0x00])
        if let gridRows = gridRows {
            self.gridRows = gridRows
            self.buffer = [UInt16](repeating: 0x0000, count: gridRows)
        }
        print("System Setup Complete")
        set(blinkRate: blinkRate)
        print("Blink rate set")
        set(brightness: brightness)
        print("Brightness set")
        clearDisplay()
        print("Display Cleared")
    }

    public func set(brightness: UInt8) {
        try? bus.writeI2CBlockData(address: i2cAddress, command: LEDBackpack.registerDimming, values: [brightness])
    }
    
    public func set(blinkRate: BlinkRate) {
        try? bus.writeI2CBlockData(address: i2cAddress, command: LEDBackpack.registerDisplaySetup | 0x01, values: [blinkRate.rawValue])
    }
    
    public func getBuffer(row: Int) -> UInt16 {
        guard row < buffer.count else { return 0x00 }

        return buffer[row]
    }

    public func setBuffer(row: Int, value: UInt16, update: Bool = true) {
        guard row < buffer.count else { return }
        buffer[row] = value
        if update {
            writeDisplay()
        }
    }
    
    public func getBuffer() -> [UInt16] {
        let bufferCopy = buffer.map { $0 }
        return bufferCopy
    }
    
    public func writeDisplay() {
        var bytes = [UInt8]()
        for item in buffer {
            bytes.append(UInt8(item & 0x00FF))
            bytes.append(UInt8(((item >> 8) & 0x00FF)))
        }

        try? bus.writeI2CBlockData(address: i2cAddress, command: LEDBackpack.registerSetMode, values: bytes)
    }
    
    public func clearDisplay(update: Bool = true) {
        buffer = [UInt16](repeating: UInt16(0x00), count: self.gridRows)
        if update {
            writeDisplay()
        }
    }

    public func color(_ gridColor: GridColor) -> Int {
        return gridColor.rawValue
    }

    func setPixel(x: UInt16, y: Int, color: GridColor) {
        guard x < 8, y < self.gridRows else { return }

        var buffer = getBuffer()
        var value: UInt16 = 0x0000
        let u8 = UInt16(8)
        let u1 = UInt16(1)
        
        switch color {
        case .red:
            value = (buffer[y] | (u1 << x)) & ~(u1 << (x+u8))
        case .green:
            value = (buffer[y] | u1 << (x+u8)) & ~(u1 << x)
        case .orange:
            value = buffer[y] | (u1 << (x+u8)) | (u1 << x)
        case .off:
            value = buffer[y] & ~(u1 << x) & ~((u1 << (x+u8)))
        }

        setBuffer(row: y, value: value)
    }
}
