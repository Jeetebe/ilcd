//
//  ChonViewController.swift
//  Lichcupdien
//
//  Created by MacBook on 5/11/18.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import DropDown
import  Alamofire

class ChonViewController: UIViewController {

    
    @IBOutlet weak var cbTinh: UIButton!
    
   var list:[TinhObj]=[]
    
    @IBOutlet weak var btnTieptuc: DesignButton!
    
    @IBAction func tieptucclick(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "ischon")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chontinh(_ sender: Any) {
         dropDown.show()
        
    }
    
   
    let dropDown = DropDown()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropDown.anchorView = self.cbTinh
        dropDown.dataSource = ["An Giang"]
        dropDown.selectionAction = { [unowned self] (index, item) in
            let defaults = UserDefaults.standard
            let tinhobj = self.list[index]
            
            defaults.set(tinhobj.tinhid, forKey: "tinhid")
             defaults.set(tinhobj.tinhdau, forKey: "tinhdau")
            self.cbTinh.setTitle(item, for: .normal)
        }
        alamofireGetLog()
        
       
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                var todos:[String] = []
                for element in json {
                    if let todoResult = TinhObj(json: element) {
                        todos.append(todoResult.tinhdau)
                        self.list.append(todoResult)
                    }
                }
                print("out:\(self.list.count)")
                self.dropDown.dataSource = todos
                self.dropDown.reloadInputViews()
        }
        // self.indicator.stopAnimating()
        
    }


}
