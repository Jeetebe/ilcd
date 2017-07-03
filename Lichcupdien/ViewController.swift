//
//  ViewController.swift
//  Lichcupdien
//
//  Created by MacBook on 7/3/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Alamofire

class ViewController: UIViewController ,GADNativeExpressAdViewDelegate, GADVideoControllerDelegate {

    @IBOutlet weak var myHeight: NSLayoutConstraint!
    @IBOutlet weak var viewC: UIView!
    let adUnitId = "ca-app-pub-8623108209004118/6575771983"
    var list:[TinhObj]=[]
    
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var nativeExpressAdView: GADNativeExpressAdView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        alamofireGetLog()
        
        
        //admod
        nativeExpressAdView.adUnitID = adUnitId
        nativeExpressAdView.rootViewController = self
        nativeExpressAdView.delegate = self as! GADNativeExpressAdViewDelegate
        
        // The video options object can be used to control the initial mute state of video assets.
        // By default, they start muted.
        let videoOptions = GADVideoOptions()
        videoOptions.startMuted = true
        nativeExpressAdView.setAdOptions([videoOptions])
        
        // Set this UIViewController as the video controller delegate, so it will be notified of events
        // in the video lifecycle.
        nativeExpressAdView.videoController.delegate = self as! GADVideoControllerDelegate
        
        let request = GADRequest()
        //request.testDevices = [kGADSimulatorID]
        nativeExpressAdView.load(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        var cell : SampleTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Celltinh") as! SampleTableViewCell
        if(cell == nil)
        {
            cell = Bundle.main.loadNibNamed("Celllog", owner: self, options: nil)?[0] as! SampleTableViewCell;
        }
        let tinh = list[indexPath.row]._tinhdau as String //NOT NSString
        let ngay = list[indexPath.row]._ngay as String //NOT NSString
   
            cell.lbngay.text=ngay
        cell.lbtinh.text = String(indexPath.row+1) + ". " + tinh
        
      return cell
    }

    func tableViewHeight() -> CGFloat {
        myTable.layoutIfNeeded()
        
        return myTable.contentSize.height
    }

    func alamofireGetLog() {
        print("get 1song")
      
        let todoEndpoint: String = "http://123.30.100.126:8081/Restapi/rest/lichcupdien/getdmtinhsupport"
                  //print("url\(todoEndpoint)")
        Alamofire.request(todoEndpoint)
            
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print(response.result.error!)
                    //completionHandler(.failure(response.result.error!))
                    return
                }
                
                // make sure we got JSON and it's an array of dictionaries
                guard let json = response.result.value as? [[String: AnyObject]] else {
                    print("didn't get todo objects as JSON from API")
                    //                    completionHandler(.failure(BackendError.objectSerialization(reason: "Did not get JSON array in response")))
                    return
                }
                
                // turn each item in JSON in to Todo object
                //var todos:[TinhObj] = []
                self.list.removeAll()
                for element in json {
                    if let todoResult = TinhObj(json: element) {
                        //todos.append(todoResult)
                        self.list.append(todoResult)
                    }
                }
                print("out:\(self.list.count)")
                
           
                self.myTable.reloadData()
                self.myHeight.constant += self.tableViewHeight()
                self.viewC.layoutIfNeeded()
                
                
        }
    }

}

