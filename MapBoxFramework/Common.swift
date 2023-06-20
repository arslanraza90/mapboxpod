//
//  Common.swift
//  MapBoxFramework
//
//  Created by Innzamam Ul Haq on 6/20/23.
//

import Foundation
import UIKit

class Common: NSObject {
    class func showAlert (message:String?, title:String = "Alert!", viewController:UIViewController) {
        let alert = UIAlertController(title: nil,message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK",style: .cancel, handler: nil)
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
