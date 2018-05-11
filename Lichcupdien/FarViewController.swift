//
//  FarViewController.swift
//  Lichcupdien
//
//  Created by MacBook on 5/5/18.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import FBSDKShareKit

class FarViewController: UIViewController {

   var tinhobj: TinhObj!
    @IBOutlet weak var btnTinh: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlImage = NSURL(string: "https://upload.wikimedia.org/wikipedia/commons/0/0e/THSR_700T_Modern_High_Speed_Train.jpg")
        
        let link:String="http://itunes.apple.com/app/id1232657493"
        //let urlstr: String = "http://123.30.100.126:8081/Restapi/rest/lichcupdien/getdmtinhsupport"
        print("url \(link)")
        guard  let url = URL(string: link)
            
            else {
                print("loi url")
                return
        }
        
        let content = FBSDKShareLinkContent()
        content.contentURL = url
        content.quote = "Lịch cúp điện"
        
        let shareButton = FBSDKShareButton()
        //shareButton.center = CGPoint(x: view.center.x, y: 20)
        shareButton.center = CGPoint(x: view.bounds.midX , y: view.bounds.midY)
        shareButton.shareContent = content
        view.addSubview(shareButton)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = UserDefaults.standard
    
        let tinhid = defaults.string(forKey: "tinhid")
        let tinhdau = defaults.string(forKey: "tinhdau")
        
        tinhobj = TinhObj(_tinhdau: tinhdau , _tinhid: tinhid, _ngay: "")
        self.btnTinh.setTitle(tinhobj.tinhdau, for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "seqyeuthich"
        {
            let detailViewController = ((segue.destination) as! WebViewController)
            detailViewController.tinhobj = self.tinhobj
        }
    }


}
