
import Foundation
import UIKit


class ShowAlert: UIViewController {
    
    class func alertUser(styleController: UIAlertController.Style, messageTitle: String?, messageBody: String?, actionTitleOne: String?, actionStyleOne: UIAlertAction.Style, actionTitleTwo: String?, actionStyleTwo: UIAlertAction.Style , viewController: UIViewController) {
            
        let alertController = UIAlertController(title: messageTitle, message: messageBody, preferredStyle: styleController)
        let actionOne = UIAlertAction(title: actionTitleOne, style: actionStyleOne)
            alertController.addAction(actionOne)
        
        if actionTitleTwo != nil && actionTitleTwo != ""{
            let actionTwo = UIAlertAction(title: actionTitleTwo, style: actionStyleTwo)
            alertController.addAction(actionTwo)
        }
            viewController.present(alertController, animated: true)
    }

}
