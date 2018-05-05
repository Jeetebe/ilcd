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
import  Social
import ESPullToRefresh

class ViewController: UIViewController ,GADNativeExpressAdViewDelegate, GADVideoControllerDelegate {

    @IBOutlet weak var bannerView: GADBannerView!
    let link:String="Ứng dụng Lịch cúp điện  http://itunes.apple.com/app/id1232657493"
    let adUnitId = "ca-app-pub-8623108209004118/6575771983"
    var list:[TinhObj]=[]
    var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var myTable: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        alamofireGetLog()
    
        self.myTable.es.addPullToRefresh {
            [unowned self] in
            /// Do anything you want...
            self.alamofireGetLog()
            
            /// ...
            /// Stop refresh when your job finished, it will reset refresh footer if completion is true
            self.myTable.es.stopPullToRefresh(ignoreDate: true)
            /// Set ignore footer or not
            self.myTable.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
        }
        
        //ads
        bannerView.adSize=kGADAdSizeSmartBannerPortrait
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        bannerView.adUnitID = "ca-app-pub-8623108209004118/8052505184"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
       
    }
    override func loadView() {
        super.loadView()
        
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
        let tinh = list[indexPath.row].tinhdau as String //NOT NSString
        let str = list[indexPath.row]._ngay as String //NOT NSString
   
        let index1 = str.index(str.startIndex, offsetBy: 10)
        let ngay = str.substring(to: index1)
            cell.lbngay.text=ngay
        cell.lbtinh.text = String(indexPath.row+1) + ". " + tinh
        
      return cell
    }

//    func tableViewHeight() -> CGFloat {
//        myTable.layoutIfNeeded()
//
//        return myTable.contentSize.height
//    }

    func getdata() {
       let urlstr: String = "http://123.30.100.126:8081/Restapi/rest/lichcupdien/getdmtinhsupport"
        print("url \(urlstr)")
        guard  let url = URL(string: urlstr)
            
            else {
                print("loi url")
                return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            print(data)
            do {
                let tinh: TinhElement = try JSONDecoder().decode(TinhElement.self, from: data)
                //et user = User(data)
                print(tinh)
                DispatchQueue.main.async {
                    //self.list = [tinh]
                    print("size: \(self.list.count)")
                    self.myTable.reloadData()
                }
            } catch {
                print("error getdata")
            }
        }
        task.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)

    {
        print("click")
        if segue.identifier == "DetailSegue"
        {
            let detailViewController = ((segue.destination) as! WebViewController)
            
            let indexPath = self.myTable!.indexPathForSelectedRow!
            let tinhobj = list[indexPath.row]
            detailViewController.tinhobj=tinhobj
            print("tinh123:\(tinhobj.tinhdau)")
        }
    }
     func alamofireGetLog()
    {
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
        }
                // self.indicator.stopAnimating()

    }

}

