import UIKit
import CarbonKit



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
        //tabSwipe.toolbar.backgroundColor = UIColor.black
        tabSwipe.insert(intoRootViewController: self)
      
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = UserDefaults.standard
        var ischon = defaults.bool(forKey: "ischon")
        var tinhid = defaults.string(forKey: "tinhid")
        print("chon \(ischon)")
          print("tinhid \(tinhid)")
        if ischon==false
        {
            goto_page_chon()
        }
    }
    func goto_page_chon()
    {
        var storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var vc : ChonViewController = storyboard.instantiateViewController(withIdentifier: "ChonViewController") as! ChonViewController
        self.present(vc, animated: false, completion: nil)
    }
        
   
     
        
      
    
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        guard let storyboard = storyboard else { return UIViewController() }
        if index == 0 {
            return storyboard.instantiateViewController(withIdentifier: "ViewController")
        }
        return storyboard.instantiateViewController(withIdentifier: "FarViewController")
    }
    
}
