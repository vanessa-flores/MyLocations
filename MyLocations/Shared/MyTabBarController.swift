//
//  MyTabBarController.swift
//  MyLocations
//
//  Created by Vanessa Flores on 9/8/20.
//  Copyright © 2020 Rising Dev Habits. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return nil
    }

}
