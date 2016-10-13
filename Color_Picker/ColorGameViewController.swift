//
//  ColorGameViewController.swift
//  Color_Picker
//
//  Created by Dee on 3/10/2016.
//  Copyright © 2016 Dee. All rights reserved.
//

import UIKit
import SwiftyJSON

class ColorGameViewController: UIViewController {
    
    
    // Typealias for RGB color values
    typealias RGB = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    
    // Typealias for HSV color values
    typealias HSV = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
    
    var url = "http://118.139.41.63:3000/currentcolor" as String
    var rgb: RGB?
    var colors: [String] = ["red", "pink", "purple", "blue", "green", "yellow", "orange"]
    
    @IBOutlet var colorName: UILabel!
    @IBOutlet var comfirmButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI settings
        updateColorName()
        comfirmButton.layer.cornerRadius = 20
        cancelButton.layer.cornerRadius = 20
        colorName.layer.masksToBounds = true
        colorName.layer.cornerRadius = 10
        colorName.layer.borderColor = UIColor.whiteColor().CGColor
        colorName.layer.borderWidth = 3.0
        
        //print(checkColor(self.rgb2hsv((red: 157/255, green: 125/255, blue: 148/255, alpha: 1))))
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // parse RGB to color name
    func updateColorName() {
        let rand = Int(arc4random_uniform(7))
        colorName.text = colors[rand]
        switch rand {
        case 0:
            colorName.backgroundColor = UIColor(red: 255/255.0, green: 6/255.0, blue: 35/255.0, alpha: 1.0)
        case 1:
            colorName.backgroundColor = UIColor(red: 249.0/255.0, green: 135/255.0, blue: 213/255.0, alpha: 1.0)
        case 2:
            colorName.backgroundColor = UIColor(red: 126/255.0, green: 11/255.0, blue: 207/255.0, alpha: 1.0)
        case 3:
            colorName.backgroundColor = UIColor(red: 27/255.0, green: 159/255.0, blue: 252/255.0, alpha: 1.0)
        case 4:
            colorName.backgroundColor = UIColor(red: 42/255.0, green: 185/255.0, blue: 69/255.0, alpha: 1.0)
        case 5:
            colorName.backgroundColor = UIColor(red: 251/255.0, green: 233/255.0, blue: 29/255.0, alpha: 1.0)
        case 6:
            colorName.backgroundColor = UIColor(red: 249/255.0, green: 159/255.0, blue: 18/255.0, alpha: 1.0)
        default:
            colorName.backgroundColor = UIColor.blackColor()
        }
    }
    
    @IBAction func confirmChoice(sender: UIButton) {
        downloadColorData()
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // Download current color from the server and check network connection
    // solution from: http://docs.themoviedb.apiary.io/#reference/movies/movienowplaying
    func downloadColorData(){
        let url = NSURL(string: self.url)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            print(error)
            if let data = data {
                self.parseColorJSON(data)
                dispatch_async(dispatch_get_main_queue()) {
                    if (self.colorName.text == ColorManager.colorManager.checkColor(ColorManager.colorManager.rgb2hsv(self.rgb!))) {
                        // successful counts plus 1
                        GameManager.gameManager.saveCounts("win")
                        // if the user win the game, popup an alert and let them to choose whether start a new game or not
                        let messageString: String = "Congratulations!"
                        // Setup an alert to warn user
                        // UIAlertController manages an alert instance
                        let alertController = UIAlertController(title: "Message", message: messageString, preferredStyle:
                            UIAlertControllerStyle.Alert)
                        
                        alertController.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.Default,handler: { (action: UIAlertAction!) in
                                self.updateColorName()
                        }))
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    } else {
                        // failed counts plus 1
                        GameManager.gameManager.saveCounts("lose")
                        // a message to alert user that they lose the game
                        let messageString: String = "Sorry, please try again."
                        // Setup an alert to warn user
                        // UIAlertController manages an alert instance
                        let alertController = UIAlertController(title: "Alert", message: messageString, preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                    if self.rgb == nil {
                        let messageString: String = "Something wrong with the connection"
                        // Setup an alert to warn user
                        // UIAlertController manages an alert instance
                        let alertController = UIAlertController(title: "Alert", message: messageString, preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
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
        
        // Download movies
    }
    
    // Parse the received json result
    // solution from: https://github.com/SwiftyJSON/SwiftyJSON
    // and https://www.hackingwithswift.com/example-code/libraries/how-to-parse-json-using-swiftyjson
    func parseColorJSON(movieJSON:NSData){
        do{
            let result = try NSJSONSerialization.JSONObjectWithData(movieJSON,
                                                                    options: NSJSONReadingOptions.MutableContainers)
            let json = JSON(result)
            print(json)
            
            NSLog("Found \(json.count) new results!")
            for color in json.arrayValue {
                if let
                    time = color["time"].string,
                    red = color["red"].double,
                    green = color["green"].double,
                    blue = color["blue"].double {
                    rgb = (red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
                }
            }
        }catch {
            print("JSON Serialization error")
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
