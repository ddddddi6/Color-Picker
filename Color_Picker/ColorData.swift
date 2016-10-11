//
//  ColorData.swift
//  Color_Picker
//
//  Created by Dee on 11/10/2016.
//  Copyright © 2016 Dee. All rights reserved.
//

import UIKit

class ColorData: NSObject {
    var time: String?
    var red: CGFloat?
    var green: CGFloat?
    var blue: CGFloat?

    override init()
    {
        self.time = "Unknown"
        self.red = 0
        self.blue = 0
        self.green = 0
        // Default intialization of each variables
    }
    
    init(time: String, red: CGFloat, green: CGFloat, blue: CGFloat)
    {
        self.time = time
        self.red = red
        self.green = green
        self.blue = blue
        // Custome initialization of each variables
    }

}
