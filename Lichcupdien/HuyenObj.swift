//
//  TinhObj.swift
//  IOS8SwiftTabBarControllerTutorial
//
//  Created by MacBook on 4/30/17.
//  Copyright © 2017 Arthur Knopper. All rights reserved.
//

import Foundation
import SwiftyJSON

class TinhObj: NSObject, NSCoding
{
    required init(coder aDecoder: NSCoder) {
        
        tinhdau = (aDecoder.decodeObject(forKey: "tinhdau") as? String)!
        tinhid = (aDecoder.decodeInteger(forKey: "tinhid") as? String)!
        _ngay = (aDecoder.decodeInteger(forKey: "_ngay") as? String)!
    }
    
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(tinhdau, forKey: "tinhdau")
        aCoder.encode(tinhid, forKey: "tinhid")
        aCoder.encode(_ngay, forKey: "_ngay")
        
    }
    
    var tinhdau:String = ""
    var tinhid:String = ""
    var _ngay:String = ""
     required init?(_tinhdau: String?, _tinhid: String?, _ngay: String?) {
        self.tinhdau = _tinhdau!
        self.tinhid=_tinhid!
        self._ngay=_ngay!
     
        
    }

    required init?(json: SwiftyJSON.JSON) {
        self.tinhdau = json["tinhdau"].string!
        self.tinhid = json["tinhid"].string!
        self._ngay = json["maxdate"].string!
          }
    
    convenience init?(json: [String: Any]) {
        guard let _tinhdau = json["tinhdau"] as? String,
            let _tinhid = json["tinhid"] as? String,
            let _ngay = json["maxdate"] as? String
                       else {
                return nil
        }
        
        self.init(_tinhdau:_tinhdau,_tinhid:_tinhid,_ngay:_ngay)    }
    
}
