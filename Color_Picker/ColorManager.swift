//
//  ColorManager.swift
//  Color_Picker
//
//  Created by Dee on 11/10/2016.
//  Copyright © 2016 Dee. All rights reserved.
//

import UIKit

class ColorManager: NSObject {
    static let colorManager = ColorManager()
    
    // Typealias for RGB color values
    typealias RGB = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    
    // Typealias for HSV color values
    typealias HSV = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)

    // Convert RGB to HSV
    func rgb2hsv(rgb: RGB) -> HSV {
        // Converts RGB to a HSV color
        var hsb: HSV = (hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 0.0)
        
        let rd: CGFloat = rgb.red
        let gd: CGFloat = rgb.green
        let bd: CGFloat = rgb.blue
        
        let maxV: CGFloat = max(rd, max(gd, bd))
        let minV: CGFloat = min(rd, min(gd, bd))
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        
        let d: CGFloat = maxV - minV
        
        s = maxV == 0 ? 0 : d / minV;
        
        if (maxV == minV) {
            h = 0
            s = 0
            b = minV
        } else {
            let d: CGFloat = (rd==minV) ? gd-bd : ((bd==minV) ? rd-gd : bd-rd)
            let e: CGFloat = (rd==minV) ? 3 : ((bd==minV) ? 1 : 5);
            h = (e - d/(maxV - minV)) / 6.0;
            s = (maxV - minV)/maxV;
            b = maxV;
        }
        
        hsb.hue = h
        print(h)
        hsb.saturation = s
        hsb.brightness = b
        hsb.alpha = rgb.alpha
        return hsb
    }

    // Convert hsv to color name
    func checkColor(hsb: HSV) -> String {
        var color: String = ""
        let h = hsb.hue * 360
        print(h)
        if (h >= 0 && h <= 30) {
            color = "red"
        } else if (h >= 345 && h <= 360) {
            color = "red"
        } else if (h >= 320 && h <= 344) {
            color = "pink"
        } else if (h >= 245 && h <= 319) {
            color = "purple"
        } else if (h >= 205 && h <= 244) {
            color = "blue"
        } else if (h >= 75 && h <= 204) {
            color = "green"
        } else if (h >= 46 && h <= 74) {
            color = "yellow"
        } else if (h >= 30 && h <= 45) {
            color = "orange"
        }
        return color
    }
}
