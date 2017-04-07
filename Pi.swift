//
//  Pi.swift
//  
//
//  Created by Stuart Levine on 4/1/17.
//
//

import Foundation

import Glibc

typealias Point = (x: Int, y: Int)

extension LEDBackpack {
    
    func swap(xyPoint point: Point) -> Point {
        return (point.y, point.x)
    }
    
    func drawLine(p0: Point, p1: Point, color: LEDBackpack.GridColor) {
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
                self.setPixel(x: UInt16(y), y: x, color: color)
            }
            else {
                self.setPixel(x: UInt16(x), y: y, color: color)
            }
            err -= dy
            if err < 0 {
                y += yStep
                err += dx
            }
        }
    }
    
    func drawRect(origin p: Point, w: Int, h: Int, color: LEDBackpack.GridColor) {
        drawLine(p0: p, p1: (x: p.x+w-1, y: p.y), color: color)
        drawLine(p0: (x: p.x+w-1, y: p.y), p1: (x: p.x+w-1, y: p.y+h-1), color: color)
        drawLine(p0: (x: p.x+w-1, y: p.y+h-1), p1: (x: p.x, y: p.y+h-1), color: color)
        drawLine(p0: (x: p.x, y: p.y+h-1), p1: p, color: color)
    }
}

func randomNumber(inRange range: CountableClosedRange<Int>) -> Int {
    guard let x = range.first, let y = range.last else { return 0 }
    
    var r:Int = random() % (y+1)
    r = max(x, r)
    
    return r
}

let numbers: [String: [[Int]]] = [
    "0": [[1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1],
          [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6],
          [0, 2], [0, 3], [0, 4], [0, 5],
          [7, 2], [7, 3], [7, 4], [7, 5]
    ],
    "1": [[0, 4], [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4], [7, 4]
    ],
    "2": [[5, 6], [6, 6], [6, 1],
          [1, 1], [0, 1],
          [0, 2], [0, 3], [0, 4], [0, 5], [0, 6],
          [4, 4], [4, 5],
          [3, 3],
          [2, 2],
          [7, 2], [7, 3], [7, 4], [7, 5]
    ],
    "3": [[7, 1], [7, 2], [7, 3], [7, 4], [7, 5],
          [6, 6], [5, 6],
          [4, 2], [4, 3], [4, 4], [4, 5],
          [0, 1], [0, 2], [0, 3], [0, 4], [0, 5],
          [1, 6], [2, 6], [3, 6]
    ],
    "4": [[6, 1], [5, 1], [4, 1], [3, 1],
          [7, 5], [6, 5], [5, 5], [4, 5], [3, 5], [2, 5], [1, 5], [0, 5],
          [3, 1], [3, 2], [3, 3], [3, 4], [3, 5], [3, 6]
    ],
    "5": [[4, 1], [5, 1], [6, 1],
          [1, 6], [2, 6], [3, 6],
          [0, 1], [0, 2], [0, 3], [0, 4], [0, 5],
          [4, 2], [4, 3], [4, 4], [4, 5],
          [7, 1], [7, 2], [7, 3], [7, 4], [7, 5]
    ],
    "6": [[4, 1], [5, 1], [6, 1],
          [1, 6], [2, 6], [3, 6],
          [3, 1], [2, 1], [1, 1],
          [0, 2], [0, 3], [0, 4], [0, 5],
          [4, 2], [4, 3], [4, 4], [4, 5],
          [7, 2], [7, 3], [7, 4], [7, 5]
    ],
    "7": [[7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6],
          [6, 6], [5, 5], [4, 5], [3, 4], [2, 3], [1, 2], [0, 2]
    ],
    "8": [[7, 2], [7, 3], [7, 4], [7, 5],
          [4, 2], [4, 3], [4, 4], [4, 5],
          [0, 2], [0, 3], [0, 4], [0, 5],
          [6, 1], [5, 1], [3, 1], [2, 1], [1, 1],
          [6, 6], [5, 6], [3, 6], [2, 6], [1, 6]
    ],
    "9": [[7, 2], [7, 3], [7, 4], [7, 5],
          [3, 2], [3, 3], [3, 4], [3, 5],
          [0, 6],
          [6, 1], [5, 1], [4, 1],
          [6, 6], [5, 6], [4, 6], [3, 6], [2, 6], [1, 6]
    ]]

let led8 = try? LEDBackpack()

let sigHandler: Signals.SigActionHandler = { signal in
    print("(\(signal)) Cleaning up...")
    led8?.clearDisplay()
    exit(0)
}

var digitsOfPi = 1001

Signals.trap(signals: [(signal: .abrt, action: sigHandler),
                       (signal: .int, action: sigHandler),
                       (signal: .quit, action: sigHandler),
                       (signal: .term, action: sigHandler)])

func fillMatrix(num: [[Int]], color: LEDBackpack.GridColor) {
    var charMatrix = [[Int]](repeating: [Int](repeating: 0, count: 8), count: 8)
    for a in 0..<num.count {
        let x = num[a][0]
        let y = num[a][0]
        charMatrix[x][y] = color.rawValue
    }
}

func display(number num: [[Int]], color: LEDBackpack.GridColor) {
    for a in 0..<num.count {
        let x = num[a][0]
        let y = num[a][1]
        led8?.setPixel(x: UInt16(x), y: y, color: color)
    }
    Thread.sleep(forTimeInterval: 0.1)
    led8?.clearDisplay()
}

func displayAndScroll(number num: [[Int]], color: LEDBackpack.GridColor) {
    for h in 0...7 {
        let n = num.count
        for a in 0..<n {
            let x = num[a][0]
            let y = num[a][1] - h
            guard y >= 0 else { continue }
            led8?.setPixel(x: UInt16(x), y: y, color: color)
        }
        Thread.sleep(forTimeInterval: 0.05)
        led8?.clearDisplay()
    }
}

let piGenerator = Coroutine<BigInt> { (yield) in
    var q: BigInt = 1
    var r: BigInt = 0
    var t: BigInt = 1
    var k: BigInt = 1
    var m: BigInt = 3
    var x: BigInt = 3

    while digitsOfPi > 0 {
        if 4 * q + r - t < m * t {
            yield(m)
            let q0 = 10*q
            let r0 = 10*(r-m*t)
            let m0 = ((10*(3*q+r))/t) - 10*m
            q = q0
            r = r0
            m = m0
            digitsOfPi -= 1
        }
        else {
            let q0 = q*k
            let r0 = (2*q+r)*x
            let t0 = t*x
            let k0 = k+1
            let m0 = ((q*(7*k+2)+r*x)/(t*x))
            let x0 = x+2
            q = q0
            r = r0
            t = t0
            k = k0
            m = m0
            x = x0
        }
    }
}

let piSequence = AnySequence { piGenerator }
var firstDigit = true

for i in piSequence {
    led8?.clearDisplay()
    let s = String(describing: i)
    print(s, terminator: "")
    if firstDigit {
        firstDigit = false
        print(".", terminator: "")
    }

    display(number: numbers[s]!, color: .green)
}
