//
//  TinhObj.swift
//  IOS8SwiftTabBarControllerTutorial
//
//  Created by MacBook on 4/30/17.
//  Copyright © 2017 Arthur Knopper. All rights reserved.
//

import Foundation
import SwiftyJSON

class TinhObj
{
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
