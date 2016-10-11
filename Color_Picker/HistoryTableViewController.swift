//
//  HistoryTableViewController.swift
//  Color_Picker
//
//  Created by Dee on 3/10/2016.
//  Copyright © 2016 Dee. All rights reserved.
//

import UIKit
import SwiftyJSON

class HistoryTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet var winLabel: UILabel!
    @IBOutlet var loseLabel: UILabel!
    @IBOutlet var updatesField: UITextField!
    
    // Typealias for RGB color values
    typealias RGB = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)

    var rgb: RGB?
    var pickOption = ["5", "10", "15", "20", "25"]
    var c: ColorData!
    
    // Define a NSMutableArray to store all required data
    var lastUpdates: NSMutableArray
    required init?(coder aDecoder: NSCoder) {
        self.lastUpdates = NSMutableArray()
        super.init(coder: aDecoder)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.clearColor()
        
        var win: String!
        var lose: String!
        
        if (GameManager.gameManager.getCounts() == nil) {
            win = "0"
            lose = "0"
        } else {
            win = String(GameManager.gameManager.getCounts()!["win"]!)
            lose = String(GameManager.gameManager.getCounts()!["lose"]!)
        }
        
        winLabel.text = "You won: " + win
        loseLabel.text = "You lose: " + lose
        
        let pickerView = UIPickerView(frame: CGRectMake(0, 200, view.frame.width, 300))
        pickerView.backgroundColor = .whiteColor()
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(HistoryTableViewController.donePicker(_:)))

        
        toolBar.setItems([doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        updatesField.inputView = pickerView
        updatesField.inputAccessoryView = toolBar
        
        updatesField.text = "5"
        
        let url = "http://118.139.55.105:3000/lastncolor?n=" + updatesField.text! as String
        
        downloadColorData(url)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Download historical color data from the server and check network connection
    // solution from: http://docs.themoviedb.apiary.io/#reference/movies/movienowplaying
    func downloadColorData(url: String){
        let url = NSURL(string: url)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            print(error)
            if let response = response, data = data {
                self.parseColorJSON(data)
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
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
                    let c: ColorData = ColorData(time: time, red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255))
                    lastUpdates.addObject(c)
                }
            }
        }catch {
            print("JSON Serialization error")
        }
    }
    
    func donePicker(sender: UIBarButtonItem) {
        if updatesField.editing {
            updatesField.resignFirstResponder()
            let url = "http://118.139.55.105:3000/lastncolor?n=" + updatesField.text! as String
            lastUpdates.removeAllObjects()
            downloadColorData(url)
        }
    }
    


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch(section)
        {
        case 0: return self.lastUpdates.count
        case 1: return 1
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "HistoryTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HistoryTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        // Configure the cell...
        let c: ColorData = self.lastUpdates[indexPath.row] as! ColorData
        if (c.time != nil) {
            cell.timeLabel.text = c.time
        }
        if (c.red != nil && c.green != nil && c.blue != nil) {
            rgb = (red: c.red!/255, green: c.green!/255, blue: c.blue!/255, alpha: 1.0)

            cell.colorLabel.text = ColorManager.colorManager.checkColor(ColorManager.colorManager.rgb2hsv(rgb!))
            cell.colorLabel.textColor = UIColor.blueColor()
                //UIColor(red: c.red!/255, green: c.green!/255, blue: c.blue!/255, alpha: 1.0)
        }
        return cell
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updatesField.text = pickOption[row]
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
