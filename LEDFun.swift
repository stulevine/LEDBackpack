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
    ],
    ".": [[0,3], [0,4], [1,3], [1,4]],
    "/": [[7,0], [6,1], [5,2], [4,3], [3,4], [2,5], [1,6], [0,7]],
    "|": [[7,7], [6,6], [5,5], [4,4], [3,3], [2,2], [1,1], [0,0]]
]

func randomColor(inRange range: CountableClosedRange<Int>) -> LEDBackpack.GridColor {
    let color = randomNumber(inRange: range)
    switch color {
    case 1: return LEDBackpack.GridColor.red
    case 2: return LEDBackpack.GridColor.green
    case 3: return LEDBackpack.GridColor.orange
    default: return LEDBackpack.GridColor.off
    }
}

func randomGrid(led led8: LEDBackpack?) {
    var gridCount: Int = 0
    var grid = [[Bool]](repeating: [Bool](repeating: false, count: 8), count: 8)
    
    // Fill randomly without replacement
    while gridCount < 64 {
        let x = randomNumber(inRange: 0...7)
        let y = randomNumber(inRange: 0...7)
        let color = randomColor(inRange: 1...3)
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
        guard grid[x][y] == true else { continue }
        
        led8?.setPixel(x: UInt16(x), y: y, color: .off)
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

    func swap(xyPoint point: Point) -> Point {
        return (point.y, point.x)
    }
    
    func drawLine(p0: Point, p1: Point, color: GridColor) {
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
    
    func display(number num: [[Int]], color: LEDBackpack.GridColor, sleep: Bool = true) {
        for a in 0..<num.count {
            let x = num[a][0]
            let y = num[a][1]
            self.setPixel(x: UInt16(x), y: y, color: color)
        }

        if sleep {
            Thread.sleep(forTimeInterval: 0.1)
        }
        self.clearDisplay()
    }

    func displayAndScroll(number num: [[Int]], color: LEDBackpack.GridColor) {
        for h in 0...7 {
            let n = num.count
            for a in 0..<n {
                let x = num[a][0]
                let y = num[a][1] - h
                guard y >= 0 else { continue }
                self.setPixel(x: UInt16(x), y: y, color: color)
            }
            //Thread.sleep(forTimeInterval: 0.05)
            self.clearDisplay()
        }
    }

}

srandom(UInt32(time(nil)))

let led8 = try? LEDBackpack()


let sigHandler: Signals.SigActionHandler = { signal in
    print("(\(signal)) Cleaning up...")
    led8?.clearDisplay()
    exit(0)
}

Signals.trap(signals: [(signal: .abrt, action: sigHandler),
                       (signal: .int, action: sigHandler),
                       (signal: .quit, action: sigHandler),
                       (signal: .term, action: sigHandler)])

class ScrollBuffer {
    
    var buffer = [[Bool]](repeating: [Bool](repeating: false, count: 16), count: 8)
    var pointer = 0
    
    enum Position {
        case first
        case last
        
        var offset: Int {
            switch self {
                case .first: return 0
                case .last: return 8
            }
        }
    }
    
    func insert(item: [[Int]], pos: Position) {
        let offset = pos.offset
        for x in 0...7 {
            for y in 0+offset...7+offset {
                buffer[x][y] = false
            }
        }
        for p in item {
            let x = p[0]
            let y = p[1] + offset
            buffer[x][y] = true
        }
    }
    
    func itemAndShift(inc: Int) -> [[Int]] {
        var item = [[Int]]()
        
        for x in 0...7 {
            for y in 0...7 {
                if buffer[x][y] {
                    item.append([x, y])
                }
            }
        }
        
        for x in 0...7 {
            for y in 0...14 {
                buffer[x][y] = buffer[x][y+1]
            }
        }

        return item
    }
}

// orange pixel in each corner, cross of red and green
led8?.clearDisplay()
led8?.setPixel(x: 0, y: 0, color: .orange)
led8?.setPixel(x: 7, y: 0, color: .orange)
led8?.setPixel(x: 0, y: 7, color: .orange)
led8?.setPixel(x: 7, y: 7, color: .orange)
led8?.drawLine(p0: (x: 0, y: 3), p1: (x: 7, y: 3), color: .green)
led8?.drawLine(p0: (x: 0, y: 4), p1: (x: 7, y: 4), color: .red)
led8?.drawLine(p0: (x: 3, y: 0), p1: (x: 3, y: 7), color: .green)
led8?.drawLine(p0: (x: 4, y: 0), p1: (x: 4, y: 7), color: .red)
Thread.sleep(forTimeInterval: 3.0)

let pi = "1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482337867831652712019091456485669234603486104543266482133936072602491412737245870066063155881748815209209628292540917153643678925903600113305305488204665213841469519415116094330572703657595919530921861173819326117931051185480744623799627495673518857527248912279381830119491298336733624406566430860213949463952247371907021798609437027705392171762931767523846748184676694051320005681271452635608277857713427577896091736371787214684409012249534301465495853710507922796892589235420199561121290219608640344181598136297747713099605187072113499999983729780499510597317328160963185950244594553469083026425223082533446850352619311881710100031378387528865875332083814206171776691473035982534904287554687311595628638823537875937519577818577805321712268066130019278766111959092164201989 "

// concentric rectangles
led8?.clearDisplay()
led8?.drawRect(origin: (x: 0, y: 0), w: 8, h: 8, color: .orange)
led8?.drawRect(origin: (x: 1, y: 1), w: 6, h: 6, color: .green)
led8?.drawRect(origin: (x: 2, y: 2), w: 4, h: 4, color: .red)
led8?.drawRect(origin: (x: 3, y: 3), w: 2, h: 2, color: .orange)
Thread.sleep(forTimeInterval: 3.0)

led8?.clearDisplay()
let sb = ScrollBuffer()
sb.insert(item: numbers["|"]!, pos: ScrollBuffer.Position.first)
sb.insert(item: numbers["/"]!, pos: ScrollBuffer.Position.last)
let waves = "|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/|/" 
for n in 0..<waves.characters.count {
    for i in 0...7 {
        let num = sb.itemAndShift(inc: i)
        led8?.display(number: num, color: .red)
    }
    let digit = String(describing: waves[waves.index(waves.startIndex, offsetBy: n)])
    sb.insert(item: numbers[digit]!, pos: ScrollBuffer.Position.last)
}

Thread.sleep(forTimeInterval: 5.0)
// random fill and then random remove
led8?.clearDisplay()
randomGrid(led: led8)
led8?.clearDisplay()
