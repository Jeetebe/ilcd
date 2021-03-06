//
//  WebViewController.swift
//  Lichcupdien
//
//  Created by MacBook on 7/5/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit
import  GoogleMobileAds
import DropDown
import  Alamofire
import Social
import FBSDKShareKit

class WebViewController: UIViewController, GADRewardBasedVideoAdDelegate,GADInterstitialDelegate {
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        
    }

    
    
    var tinhobj:TinhObj!
    var list=[HuyenObj]()
    var url = "http://123.30.100.126:8081/weblogalarm/lichmatdienv3.1.jsp?huyenid=toantinh&device=ios&tinhid="
    var urlhuyen = "http://123.30.100.126:8081/weblogalarm/lichmatdienv3.1.jsp?device=ios&tinhid="
    
    let dropDown = DropDown()
    
    var interstitial: GADInterstitial!


    @IBAction func share(_ sender: Any) {
                var img = captureScreen()
       
//                let photo:FBSDKSharePhoto = FBSDKSharePhoto()
//
//                photo.image = #imageLiteral(resourceName: "star2")
//                photo.isUserGenerated = false
//        photo.caption = "Lich cup dien"
//
//                let content:FBSDKSharePhotoContent = FBSDKSharePhotoContent()
//                content.photos = [photo]
//
//                let shareButton = FBSDKShareButton()
//                //shareButton.center = view.center
//
//                shareButton.shareContent = content
//
//                shareButton.center = CGPoint(x: view.bounds.midX , y: view.bounds.maxY - 40)
//                self.view.addSubview(shareButton)
       
        let photo:FBSDKSharePhoto = FBSDKSharePhoto()
        
        photo.image =  img
        photo.isUserGenerated = true
        
        let content:FBSDKSharePhotoContent = FBSDKSharePhotoContent()
        content.photos = [photo]
        
        let shareButton = FBSDKShareButton()
        shareButton.center = view.center
        
        shareButton.shareContent = content
        
        //shareButton.center = self.view.center
        shareButton.center = CGPoint(x: view.bounds.midX , y: view.bounds.maxY - 20)
        self.view.addSubview(shareButton)
        
        
    }
    @IBAction func starclick(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(tinhobj.tinhid, forKey: "tinhid")
        defaults.set(tinhobj.tinhdau, forKey: "tinhdau")
        
        self.btnstar.setImage(#imageLiteral(resourceName: "star2"), for: .normal)
    }
    
    @IBOutlet weak var btnstar: UIButton!
    

    @IBOutlet weak var btnchon: UILabel!
    @IBAction func back(_ sender: Any) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
             self.dismiss(animated: false, completion: nil)
        }
       
    }
    
    
    
    func captureScreen() -> UIImage
    {
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, 0);
        
        self.view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return image
    }
    @IBOutlet weak var mywebview: UIWebView!

    //var requestURL:NSURL;
    @IBOutlet weak var lbTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        print(tinhobj.tinhid)
        lbTitle.text=tinhobj.tinhdau
        url=url+tinhobj.tinhid
        //print(url)
        
        let requestURL = NSURL(string:url)!
        let request = URLRequest(url: requestURL as URL)
        
        mywebview.loadRequest(request)
        
        
        dropDown.anchorView = self.btnchon
        dropDown.dataSource = ["Car", "Motorcycle", "Truck"]
        dropDown.selectionAction = { [unowned self] (index, item) in
            let huyenid=self.list[index]._tinhid
            print("huyenid: \(huyenid)")
            let url2=self.urlhuyen+self.tinhobj.tinhid + "&huyenid=" + huyenid
            print(url2)
            let requestURL = NSURL(string:url2)
            let request = URLRequest(url: requestURL! as URL)
            
            self.mywebview.loadRequest(request)
            
        }

        alamofireGetLog()
        


        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8623108209004118/5622775628")
        let request2 = GADRequest()
        interstitial.load(request2)
        interstitial.delegate = self
    }
    func createAndLoadInterstitial() -> GADInterstitial {
        //        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-8623108209004118/4267318788")
        //        interstitial.delegate = self as! GADInterstitialDelegate
        //        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        // interstitial = createAndLoadInterstitial()
        self.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func chon_huyen(_ sender: Any) {
        dropDown.show()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func alamofireGetLog() {
        print("get huyen")
        
        let todoEndpoint: String = "http://123.30.100.126:8081/Restapi/rest/lichcupdien/getdmhuyen?tinhid="+tinhobj.tinhid
        print("url\(todoEndpoint)")
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
                self.dropDown.dataSource.removeAll()
                var todos:[String] = []
                self.list.removeAll()
                for element in json {
                    if let todoResult = HuyenObj(json: element) {
                        todos.append(todoResult._tinhdau)
                        self.list.append(todoResult)
                    }
                }
                print("out:\(self.list.count)")
                self.dropDown.dataSource = todos
                self.dropDown.reloadInputViews()
                
        }
    }

}
