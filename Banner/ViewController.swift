//
//  ViewController.swift
//  Banner
//
//  Created by Yi Tong on 3/8/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let banner = Banner(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func test(_ sender: UIButton) {
        print("test")
    }
    @IBAction func failButtonTapped(_ sender: UIButton) {
//        Banner.showError(title: "Sorry", detail: "No provider available")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        Banner.isHidden ? Banner.show("sdfsdfsdfds") : Banner.hide()
       banner.show()
        
    }
}

