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
    
    var url = "http://118.139.46.33:3000/currentbaro" as String
    var currentTemperature: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        downloadTempData()
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
    
    // Download current temperature from the server and check network connection
    // solution from: http://docs.themoviedb.apiary.io/#reference/movies/movienowplaying
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
            for temp in json["results"].arrayValue {
                if let
                    time = temp["time"].string,
                    thermometer = temp["thermometer"].int{
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    dateFormatter.timeZone = NSTimeZone(name: "UTC")
                    let timestamp = dateFormatter.dateFromString(time)!
                    self.currentTemperature = thermometer
                }
            }
        }catch {
            print("JSON Serialization error")
        }
    }
    
    func changeBackgroundColor(temp: Int)  {
        if (temp >= 13 && temp <= 15) {
            self.view.backgroundColor = UIColor.blueColor()
        } else if (temp >= 16 && temp <= 18) {
            self.view.backgroundColor = UIColor.yellowColor()
        } else if (temp >= 19 && temp <= 21) {
            self.view.backgroundColor = UIColor.redColor()
        } else if (temp >= 22 && temp <= 24) {
            self.view.backgroundColor = UIColor.brownColor()
        } else if (temp >= 25 && temp <= 27) {
            self.view.backgroundColor = UIColor.darkGrayColor()
        } else if (temp >= 28 && temp <= 30) {
            self.view.backgroundColor = UIColor.cyanColor()
        } else if (temp >= 31 && temp <= 33) {
            self.view.backgroundColor = UIColor.greenColor()
        } else if (temp >= 34 && temp <= 36) {
            self.view.backgroundColor = UIColor.purpleColor()
        } else {
            self.view.backgroundColor = UIColor.blackColor()
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
