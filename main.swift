//
//  main.swift
//  Adafruit Bicolor LED Square 8x8 I2C Backpack fun!
//  To run this on a Raspberry Pi, you'll need:
//      * swift 3.0.2
//      * SMBus-swift library
//      * An Adafruit Bicolor LED Square 8x8 I2C Backpack
//      * LEDBackpack.swift - Drive Class utilizing the SMBus library
//
//  Created by Stuart Levine, 2017-03-31
//  Copyright (c) Wildcatproductions.com Apps
//
import Foundation
import Glibc

typealias Point = (x: Int, y: Int)

enum GridColor: Int {
    case red = 1
    case green = 2
    case orange = 3
}

func randomGrid(led led8: LEDBackpack?) {
    var gridCount: Int = 0
    var grid = [[Bool]](repeating: [Bool](repeating: false, count: 8), count: 8)
    
    // Fill randomly without replacement
    while gridCount < 64 {
        let x = randomNumber(inRange: 0...7)
        let y = randomNumber(inRange: 0...7)
        let color = randomNumber(inRange: 1...3)
        guard grid[x][y] == false else { continue }
        
        led8?.setPixel(x: UInt16(x), y: y, color: color)
        grid[x][y] = true
        gridCount += 1
        Thread.sleep(forTimeInterval: 0.10)
    }
    // Clear randomly without replacement
    while gridCount > 0 {
        let x = randomNumber(inRange: 0...7)
        let y = randomNumber(inRange: 0...7)
        let color = 0
        guard grid[x][y] == true else { continue }
        
        led8?.setPixel(x: UInt16(x), y: y, color: color)
        grid[x][y] = false
        gridCount -= 1
        Thread.sleep(forTimeInterval: 0.10)
    }
}

func randomNumber(inRange range: CountableClosedRange<Int>) -> Int {
    guard let x = range.first, let y = range.last else { return 0 }

    var r:Int = random() % (y+1)
    r = max(x, r)
    
    return r
}

extension LEDBackpack {
    func color(_ gridColor: GridColor) -> Int {
        return gridColor.rawValue
    }
    
    func swap(xyPoint point: Point) -> Point {
        return (point.y, point.x)
    }
    
    func drawLine(p0: Point, p1: Point, color: GridColor) {
        let iColor = self.color(color)
        let steep = abs(p1.y - p0.y) > abs(p1.x - p0.x)
        var lp0 = p0
        var lp1 = p1
        
        if steep {
            lp0 = swap(xyPoint: p0)
            lp1 = swap(xyPoint: p1)
        }
        
        if lp0.x > lp1.x {
            let x = lp0.x
            lp0.x = lp1.x
            lp1.x = x
            
            let y = lp0.y
            lp0.y = lp1.y
            lp1.y = y
        }
        
        let dx = lp1.x - lp0.x
        let dy = abs(lp1.y - lp0.y)
        
        var err = dx/2
        var yStep = 0
        
        if lp0.y < lp1.y {
            yStep = 1
        }
        else {
            yStep = -1
        }
        var y = lp0.y
        
        for x in lp0.x...lp1.x {
            if steep {
                self.setPixel(x: UInt16(y), y: x, color: iColor)
            }
            else {
                self.setPixel(x: UInt16(x), y: y, color: iColor)
            }
            err -= dy
            if err < 0 {
                y += yStep
                err += dx
            }
        }
    }
    
    func drawRect(origin p: Point, w: Int, h: Int, color: GridColor) {
        drawLine(p0: p, p1: (x: p.x+w-1, y: p.y), color: color)
        drawLine(p0: (x: p.x+w-1, y: p.y), p1: (x: p.x+w-1, y: p.y+h-1), color: color)
        drawLine(p0: (x: p.x+w-1, y: p.y+h-1), p1: (x: p.x, y: p.y+h-1), color: color)
        drawLine(p0: (x: p.x, y: p.y+h-1), p1: p, color: color)
    }
}

srandom(UInt32(time(nil)))

let led8 = try? LEDBackpack()

// orange pixel in each corner, cross of red and green
led8?.clearDisplay()
led8?.setPixel(x: 0, y: 0, color: 3)
led8?.setPixel(x: 7, y: 0, color: 3)
led8?.setPixel(x: 0, y: 7, color: 3)
led8?.setPixel(x: 7, y: 7, color: 3)
led8?.drawLine(p0: (x: 0, y: 3), p1: (x: 7, y: 3), color: .green)
led8?.drawLine(p0: (x: 0, y: 4), p1: (x: 7, y: 4), color: .red)
led8?.drawLine(p0: (x: 3, y: 0), p1: (x: 3, y: 7), color: .green)
led8?.drawLine(p0: (x: 4, y: 0), p1: (x: 4, y: 7), color: .red)
Thread.sleep(forTimeInterval: 3.0)

// concentric rectangles
led8?.clearDisplay()
led8?.drawRect(origin: (x: 0, y: 0), w: 8, h: 8, color: .orange)
led8?.drawRect(origin: (x: 1, y: 1), w: 6, h: 6, color: .green)
led8?.drawRect(origin: (x: 2, y: 2), w: 4, h: 4, color: .red)
led8?.drawRect(origin: (x: 3, y: 3), w: 2, h: 2, color: .orange)
Thread.sleep(forTimeInterval: 3.0)

// random fill and then random remove
led8?.clearDisplay()
randomGrid(led: led8)
led8?.clearDisplay()
