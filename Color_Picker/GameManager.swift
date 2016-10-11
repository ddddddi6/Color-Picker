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
    
    func setTotalCounts() {
        if (totalCounts == nil) {
            totalCounts = 1
            saveCounts()
        } else {
            totalCounts = getCounts()!["total"]! + 1
            saveCounts()
        }
    }
    
    func getTotalCounts() -> Int{
        return totalCounts!
    }
    
    func setSuccessCounts() {
        if (successCounts == nil) {
            successCounts = 1
            saveCounts()
        } else {
            successCounts = getCounts()!["win"]! + 1
            saveCounts()
        }
    }
    
    func getSuccessCounts() -> Int{
        return successCounts!
    }
    
    func setFailureCounts() {
        if (failureCounts == nil) {
            failureCounts = 1
            saveCounts()
        } else {
            failureCounts = getCounts()!["lose"]! + 1
            saveCounts()
        }
    }
    
    func getFailureCounts() -> Int{
        return failureCounts!
    }
    
    // return saved records
    func getCounts() -> [String:Int]? {
        let counts = myDefaults.objectForKey("save") as? [String:Int]
        return counts
    }
    
    func saveCounts() {
        if (myDefaults.objectForKey("save") == nil) {
            // the savedMovie `NSUserDefaults` does not exist
            if (failureCounts == nil) {
                failureCounts = 0
            }
            if (successCounts == nil) {
                successCounts = 0
            }
            
            let array = ["win": successCounts!, "lose": failureCounts!, "total": totalCounts!]
            
            // then update whats in the `NSUserDefault`
            myDefaults.setObject(array, forKey: "save")
            
            // call this after update
            myDefaults.synchronize()
            
        } else {
            // the movie has not been saved
            if (failureCounts == nil) {
                failureCounts = 0
            }
            if (successCounts == nil) {
                successCounts = 0
            }
            var array = getCounts()
            array?.updateValue(successCounts!, forKey: "win")
            array?.updateValue(failureCounts!, forKey: "lose")
            array?.updateValue(totalCounts!, forKey: "total")
            
            myDefaults.setValue(array, forKey: "save")
        }
 
    }
}
