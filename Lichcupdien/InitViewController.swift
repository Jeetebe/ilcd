import UIKit
import CarbonKit

import FBSDKShareKit

class IniiewController: UIViewController, CarbonTabSwipeNavigationDelegate {
    
    func generateImage(for view: UIView) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        return nil
    }
    
    var iconWithTextImage: UIImage {
        let button = UIButton()
        let icon = UIImage(named: "home")
        button.setImage(icon, for: .normal)
        button.setTitle("Home", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        button.sizeToFit()
        return generateImage(for: button) ?? UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabSwipe = CarbonTabSwipeNavigation(items: ["Danh mục tỉnh", "Yêu thích"], delegate: self)
        tabSwipe.setTabExtraWidth(40)
        //tabSwipe.toolbar.tintColor = UIColor.black
        tabSwipe.toolbar.backgroundColor = UIColor.black
        tabSwipe.insert(intoRootViewController: self)
        
        
        let urlImage = NSURL(string: "https://upload.wikimedia.org/wikipedia/commons/0/0e/THSR_700T_Modern_High_Speed_Train.jpg")
        
//        let imageView = UIImageView(frame: CGRectMake(0, 0, 200, 200))
//        imageView.center = CGPoint(x: view.center.x, y: 200)
//        imageView.image = UIImage(data: NSData(contentsOfURL: urlImage! as URL)!)
//        //imageView.contentMode = UIViewContentMode.ScaleAspectFit
//        view.addSubview(imageView)
         let link:String="Ứng dụng Lịch cúp điện  http://itunes.apple.com/app/id1232657493"
        //let urlstr: String = "http://123.30.100.126:8081/Restapi/rest/lichcupdien/getdmtinhsupport"
        print("url \(link)")
        guard  let url = URL(string: link)
            
            else {
                print("loi url")
                return
        }
        
        let content = FBSDKShareLinkContent()
        content.contentURL = url
       
        
       
        
        let shareButton = FBSDKShareButton()
        //shareButton.center = CGPoint(x: view.center.x, y: 20)
        shareButton.center = CGPoint(x: view.center.x + 30, y: 200)
        shareButton.shareContent = content
        view.addSubview(shareButton)
        
      
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        guard let storyboard = storyboard else { return UIViewController() }
        if index == 0 {
            return storyboard.instantiateViewController(withIdentifier: "ViewController")
        }
        return storyboard.instantiateViewController(withIdentifier: "FarViewController")
    }
    
}
