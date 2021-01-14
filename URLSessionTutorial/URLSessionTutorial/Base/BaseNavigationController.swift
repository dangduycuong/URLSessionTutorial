//
//  BaseNavigationController.swift
//  URLSessionTutorial
//
//  Created by Dang Duy Cuong on 1/14/21.
//  Copyright © 2021 Dang Duy Cuong. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        navigationBar.isTranslucent = false
        //        navigationBar.barTintColor = Constant.color.blueVSmart
        navigationBar.barTintColor = .red
        //        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: Constant.font.robotoBold(ofSize: 17)]
        let attrs = [
            //            NSAttributedString.Key.foregroundColor: UIColor.white,
            //            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 17)!
            
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 17)!
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
        navigationBar.tintColor = .white
        //        BroadCastNewInfoModel.sharedInstance.isAdded = false
    }
}
