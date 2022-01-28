//
//  Hud.swift

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

class Hud: NSObject {
    
    static var activity = UIActivityIndicatorView()

    class func show() {
        
        activity = UIActivityIndicatorView.init(frame: CGRect(x: (SCREEN_WIDTH / 2) - 30, y: (SCREEN_HEIGHT / 2) - 30, width: 60, height: 60))
                

        activity.style = .large
        activity.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5)
        activity.startAnimating()
        
        TopVC.view().addSubview(activity)
        
    }
    
    class func dismiss(){
        DispatchQueue.main.async {
            activity.stopAnimating()
            activity.hidesWhenStopped = true
        }
    }
    
}

class TopVC: NSObject {
    
    class func view() -> UIView {
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController.view
        }
        
        return keyWindow?.rootViewController?.view ?? UIView()
    }
}
