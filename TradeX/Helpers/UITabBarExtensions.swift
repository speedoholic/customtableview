//
//  CustomTabBar.swift
//  TradeX
//
//  Created by Kushal Ashok on 7/11/18.
//  Copyright © 2018 tradex. All rights reserved.
//

import UIKit

extension UITabBar {
    open func enableDarkMode() {
        self.barTintColor = COLORBLACK
        self.unselectedItemTintColor = UIColor.white
    }
}

extension UITabBarItem {
    open func enableDarkMode() {
        self.setTitleTextAttributes([NSAttributedStringKey.font: DEFAULTFONT as Any], for: .normal)
        self.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: TABBARITEMTITLEOFFSET)
        self.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : COLORYELLOW], for: .highlighted)
    }
}
