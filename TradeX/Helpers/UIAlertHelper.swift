//
//  UIAlertHelper.swift
//  ESV
//
//  Created by Kushal Ashok on 2/27/18.
//  Copyright © 2018 Essex Lake Group. All rights reserved.
//

import Foundation
import UIKit

class UIAlertHelper: NSObject {
    
    static let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    static func showAlertWithTitle(_ title: String?,
                                   message: String?,
                                   actions: [UIAlertAction] = [defaultAction],
                                   completionBlock: (() -> Void)?,
                                   onController: UIViewController?
        ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        if let controller = onController {
            controller.present(alert, animated: true, completion: completionBlock)
        } else {
            var rootViewController = UIApplication.shared.keyWindow?.rootViewController
            if let navigationController = rootViewController as? UINavigationController {
                rootViewController = navigationController.viewControllers.first
            }
            rootViewController?.present(alert, animated: true, completion: completionBlock)
        }
    }
}
