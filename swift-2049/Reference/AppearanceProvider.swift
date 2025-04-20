//
//  AppearanceProvider.swift
//  swift-2048
//
//  Created by Austin Zheng on 6/3/14.
//  Copyright (c) 2014 Austin Zheng. Released under the terms of the MIT license.
//

import UIKit

protocol AppearanceProviderProtocol: AnyObject {
    func tileColor(_ value: Int) -> UIColor
    func numberColor(_ value: Int) -> UIColor
    func fontForNumbers(size: CGFloat) -> UIFont
}

class AppearanceProvider: AppearanceProviderProtocol {
    
    // Provide a tile color for a given value
    func tileColor(_ value: Int) -> UIColor {
        switch value {
            //        case 2:
            //            return UIColor(red: 238.0/255.0, green: 228.0/255.0, blue: 218.0/255.0, alpha: 1.0)
            //        case 4:
            //            return UIColor(red: 237.0/255.0, green: 224.0/255.0, blue: 200.0/255.0, alpha: 1.0)
            //        case 8:
            //            return UIColor(red: 242.0/255.0, green: 177.0/255.0, blue: 121.0/255.0, alpha: 1.0)
            //        case 16:
            //            return UIColor(red: 245.0/255.0, green: 149.0/255.0, blue: 99.0/255.0, alpha: 1.0)
            //        case 32:
            //            return UIColor(red: 246.0/255.0, green: 124.0/255.0, blue: 95.0/255.0, alpha: 1.0)
            //        case 64:
            //            return UIColor(red: 246.0/255.0, green: 94.0/255.0, blue: 59.0/255.0, alpha: 1.0)
            //        case 128, 256, 512, 1024, 2048:
            //            return UIColor(red: 237.0/255.0, green: 207.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        case 2:
            return UIColor(red: 238.0/255.0, green: 228.0/255.0, blue: 218.0/255.0, alpha: 1.0)
        case 4:
            return UIColor(red: 237.0/255.0, green: 224.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        case 8:
            return UIColor(red: 242.0/255.0, green: 177.0/255.0, blue: 121.0/255.0, alpha: 1.0)
        case 16:
            return UIColor(red: 245.0/255.0, green: 149.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        case 32:
            return UIColor(red: 246.0/255.0, green: 124.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        case 64:
            return UIColor(red: 246.0/255.0, green: 94.0/255.0, blue: 59.0/255.0, alpha: 1.0)
        case 128:
            return UIColor(red: 237.0/255.0, green: 207.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        case 256:
            return UIColor(red: 237.0/255.0, green: 204.0/255.0, blue: 94.0/255.0, alpha: 1.0)
        case 512:
            return UIColor(red: 237.0/255.0, green: 200.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        case 1024:
            return UIColor(red: 237.0/255.0, green: 197.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        case 2048:
            return UIColor(red: 237.0/255.0, green: 194.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        default:
            return UIColor(red: 25.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 1.0)
        }
    }
    
    // Provide a numeral color for a given value
    func numberColor(_ value: Int) -> UIColor {
        switch value {
        case 2, 4:
            return UIColor(red: 119.0/255.0, green: 110.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        default:
            return UIColor.white
        }
    }
    
    // Provide the font to be used on the number tiles
    func fontForNumbers(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "HelveticaNeue-Bold", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
}
