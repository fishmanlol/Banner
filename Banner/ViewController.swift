//
//  ViewController.swift
//  Banner
//
//  Created by Yi Tong on 3/8/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit
import Bartinter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Banner.isHidden ? Banner.show("sdfsdfsdfds") : Banner.hide()
    }
}

