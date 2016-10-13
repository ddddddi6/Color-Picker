//
//  GameManager.swift
//  Color_Picker
//
//  Created by Dee on 11/10/2016.
//  Copyright © 2016 Dee. All rights reserved.
//

import UIKit

class GameManager: NSObject {
    static let gameManager = GameManager()
    
    let myDefaults = NSUserDefaults.standardUserDefaults()
    var totalCounts: Int?
    var successCounts: Int?
    var failureCounts: Int?

    
    // return saved records
    func getCounts() -> [String:Int]? {
        let counts = myDefaults.objectForKey("saves") as? [String:Int]
        return counts
    }
    
    // save game data to NSUserdefalts
    func saveCounts(condition: String) {
        if (myDefaults.objectForKey("saves") == nil) {
            // the savedMovie `NSUserDefaults` does not exist
            switch condition {
                case "win":
                    successCounts = 1
                    failureCounts = 0
                    totalCounts = 1
                    break
                case "lose":
                    successCounts = 0
                    failureCounts = 1
                    totalCounts = 1
                    break
                default:
                    successCounts = 0
                    failureCounts = 0
                    totalCounts = 0
                    break
            }
            let array = ["win": successCounts!, "lose": failureCounts!, "total": totalCounts!]
            
            // then update whats in the `NSUserDefault`
            myDefaults.setObject(array, forKey: "saves")
            
            // call this after update
            myDefaults.synchronize()
            
        } else {
            // the movie has not been saved
            switch condition {
                // if the user win the game
            case "win":
                successCounts = getCounts()!["win"]! + 1
                failureCounts = getCounts()!["lose"]!
                totalCounts = getCounts()!["total"]! + 1
                break
                // if the user lose the game
            case "lose":
                successCounts = getCounts()!["win"]!
                failureCounts = getCounts()!["lose"]! + 1
                totalCounts = getCounts()!["total"]! + 1
                break
            default:
                break
            }
            
            // update data in NSUserdefault
            var array = getCounts()
            array?.updateValue(successCounts!, forKey: "win")
            array?.updateValue(failureCounts!, forKey: "lose")
            array?.updateValue(totalCounts!, forKey: "total")
            
            myDefaults.setValue(array, forKey: "saves")
        }
 
    }
}
