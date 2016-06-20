//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "swwdc.png")
let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image!.CGImage))


let strings = ["let", "var", "for", "if", "as", "do", "in", "try",
               "(", ")", "[", "]", "<", ">",
               ".", "@", "#", "/", "\\", ":", "*", "+", "-", "=", "_", "~"]


let colors = [UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0),
              UIColor(red: 218.0 / 255.0, green: 60.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0),
              UIColor(red: 120.0 / 255.0, green: 120.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0),
              UIColor(red: 209.0 / 255.0, green: 141.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0),
              UIColor(red: 171.0 / 255.0, green: 61.0 / 255.0, blue: 141.0 / 255.0, alpha: 1.0),
              UIColor(red: 26.0 / 255.0, green: 160.0 / 255.0, blue: 160.0 / 255.0, alpha: 1.0),
              UIColor(red: 150.0 / 255.0, green: 200.0 / 255.0, blue: 115.0 / 255.0, alpha: 1.0),
]


func shouldWriteChar(pos: CGPoint) -> Bool {
    let pixel = getPixelColor(pos)
    return pixel.r < 0.1 && pixel.g < 0.1 && pixel.b < 0.1
}

func getPixelColor(pos: CGPoint) -> (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) {
//    let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage))
    let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
    
    let pixelInfo: Int = ((Int(image!.size.width) * Int(pos.y)) + Int(pos.x)) * 4
    
    let r = CGFloat(data[pixelInfo])
    let g = CGFloat(data[pixelInfo+1])
    let b = CGFloat(data[pixelInfo+2])
    let a = CGFloat(data[pixelInfo+3])
    
    return (r: r, g: g, b: b, a: a)
}



// ビューのサイズ
let size = image!.size

// UIViewを生成
let view:UIView = UIView(frame: CGRect(origin: CGPointZero, size:size))
view.backgroundColor = UIColor(red: 41.0 / 255.0, green: 43.0 / 255.0, blue: 55.0 / 255.0, alpha: 1.0)

// CoreGraphicsで描画する
UIGraphicsBeginImageContextWithOptions(size, false, 0)

// 文字を描画する
let font = UIFont(name: "Menlo-Regular", size: 10.0)

var y : CGFloat = 0.0
while (y < size.height) {
    var x : CGFloat = 0.0
    while (x < size.width) {
        if shouldWriteChar(CGPointMake(x, y)) {
            let word = strings[Int(arc4random_uniform(UInt32(strings.count)))]
            let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
            let attrString = NSAttributedString(
                string: word,
                attributes:[NSForegroundColorAttributeName: color,
                    NSFontAttributeName: font!])
            attrString.drawAtPoint(CGPointMake(x, y))
            
            x = x + attrString.size().width
         } else {
            x = x + 10
        }
    }
    y = y + 10
}

// viewのlayerに描画したものをセットする
view.layer.contents = UIGraphicsGetImageFromCurrentImageContext().CGImage

UIGraphicsEndImageContext()

// PlaygroundのTimelineに表示するためのview
let preview = view
