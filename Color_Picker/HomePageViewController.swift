//
//  HomePageViewController.swift
//  Color_Picker
//
//  Created by Dee on 1/10/2016.
//  Copyright © 2016 Dee. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomePageViewController: UIViewController {

    @IBOutlet var playButton: UIButton!
    @IBOutlet var historyButton: UIButton!
    @IBOutlet var tempLabel: UILabel!
    
    var url = "http://118.139.55.105:3000/currentbaro" as String
    var currentTemperature: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.layer.cornerRadius = 30
        historyButton.layer.cornerRadius = 30
        playButton.backgroundColor = UIColor(red: 0/255.0, green: 185/255.0, blue: 64/255.0, alpha: 1.0)
        historyButton.backgroundColor = UIColor(red: 0/255.0, green: 185/255.0, blue: 64/255.0, alpha: 1.0)
        self.view.backgroundColor = UIColor(red: 251/255.0, green: 131/255.0, blue: 154/255.0, alpha: 1.0)
        self.downloadTempData()
        updateBackgroundColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startGame(sender: UIButton) {
        //self.performSegueWithIdentifier("playGameSegue", sender: self)
    }

    @IBAction func viewHistory(sender: UIButton) {
        //self.performSegueWithIdentifier("viewHistorySegue", sender: self)
    }
    
    func updateBackgroundColor() {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.downloadTempData()
            self.updateBackgroundColor()
        }
    }
    
    // Download current temperature from the server and check network connection
    func downloadTempData(){
        let url = NSURL(string: self.url)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = NSURLSession.sharedSession()
        let priority = QOS_CLASS_USER_INTERACTIVE
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if let response = response, data = data {
                    self.parseTempJSON(data)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tempLabel.text = String(self.currentTemperature!)
                        self.changeBackgroundColor(self.currentTemperature!)
                    }
                } else {
                    let messageString: String = "Something wrong with the connection"
                    // Setup an alert to warn user
                    // UIAlertController manages an alert instance
                    let alertController = UIAlertController(title: "Alert", message: messageString, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            task.resume()
        }
        // Download movies
    }
    
    // Parse the received json result
    // solution from: https://github.com/SwiftyJSON/SwiftyJSON
    // and https://www.hackingwithswift.com/example-code/libraries/how-to-parse-json-using-swiftyjson
    func parseTempJSON(movieJSON:NSData){
        do{
            let result = try NSJSONSerialization.JSONObjectWithData(movieJSON,
                                                                    options: NSJSONReadingOptions.MutableContainers)
            let json = JSON(result)
            
            NSLog("Found \(json["results"].count) new results!")
            if let
                time = json["time"].string,
                thermometer = json["thermometer"].int{
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                dateFormatter.timeZone = NSTimeZone(name: "UTC")
                //let timestamp = dateFormatter.dateFromString(time)!
                self.currentTemperature = thermometer
            }
        }catch {
            print("JSON Serialization error")
        }
    }
    
    func changeBackgroundColor(temp: Int)  {
        if (temp >= 10 && temp <= 11) {
            self.view.backgroundColor = UIColor(red: 4/255.0, green: 147/255.0, blue: 218/255.0, alpha: 1.0)
        } else if (temp >= 12 && temp <= 13) {
            self.view.backgroundColor = UIColor(red: 28/255.0, green: 171/255.0, blue: 241/255.0, alpha: 1.0)
        } else if (temp >= 14 && temp <= 15) {
            self.view.backgroundColor = UIColor(red: 98/255.0, green: 198/255.0, blue: 252/255.0, alpha: 1.0)
        } else if (temp >= 15 && temp <= 16) {
            self.view.backgroundColor = UIColor(red: 123/255.0, green: 217/255.0, blue: 255/255.0, alpha: 1.0)
        } else if (temp >= 16 && temp <= 17) {
            self.view.backgroundColor = UIColor(red: 134/255.0, green: 230/255.0, blue: 255/255.0, alpha: 1.0)
        } else if (temp >= 17 && temp <= 18) {
            self.view.backgroundColor = UIColor(red: 150/255.0, green: 247/255.0, blue: 254/255.0, alpha: 1.0)
        } else if (temp >= 19 && temp <= 20) {
            self.view.backgroundColor = UIColor(red: 175/255.0, green: 255/255.0, blue: 246/255.0, alpha: 1.0)
        } else if (temp >= 21 && temp <= 22) {
            self.view.backgroundColor = UIColor(red: 200/255.0, green: 255/255.0, blue: 215/255.0, alpha: 1.0)
        } else if (temp >= 23 && temp <= 24) {
            self.view.backgroundColor = UIColor(red: 223/255.0, green: 255/255.0, blue: 180/255.0, alpha: 1.0)
        } else if (temp >= 25 && temp <= 26) {
            self.view.backgroundColor = UIColor(red: 246/255.0, green: 255/255.0, blue: 148/255.0, alpha: 1.0)
        } else if (temp >= 27 && temp <= 28) {
            self.view.backgroundColor = UIColor(red: 255/255.0, green: 226/255.0, blue: 72/255.0, alpha: 1.0)
        } else if (temp >= 29 && temp <= 30) {
            self.view.backgroundColor = UIColor(red: 255/255.0, green: 204/255.0, blue: 43/255.0, alpha: 1.0)
        } else if (temp >= 31 && temp <= 32) {
            self.view.backgroundColor = UIColor(red: 254/255.0, green: 153/255.0, blue: 1/255.0, alpha: 1.0)
        } else if (temp >= 33 && temp <= 34) {
            self.view.backgroundColor = UIColor(red: 255/255.0, green: 104/255.0, blue: 1/255.0, alpha: 1.0)
        } else if (temp >= 35 && temp <= 36) {
            self.view.backgroundColor = UIColor(red: 255/255.0, green: 38/255.0, blue: 10/255.0, alpha: 1.0)
        } else {
            self.view.backgroundColor = UIColor(red: 251/255.0, green: 131/255.0, blue: 154/255.0, alpha: 1.0)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "playGameSegue") {
            let controller = segue.destinationViewController as! ColorGameViewController
            controller.view.backgroundColor = self.view.backgroundColor
        } else if (segue.identifier == "viewHistorySegue") {
            let controller = segue.destinationViewController as! HistoryTableViewController
            controller.view.backgroundColor = self.view.backgroundColor
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
