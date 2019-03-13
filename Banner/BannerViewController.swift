//
//  BannerViewController.swift
//  Banner
//
//  Created by Yi Tong on 3/12/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit
import SnapKit

class BannerViewController: UIViewController {
    weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        setup()
    }
    
    func setup() {
        let sv = UIScrollView()
        sv.backgroundColor = .red
        sv.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 90)
        
        scrollView = sv
        view.addSubview(scrollView)
        
        sv.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let v1 = UIView()
        v1.backgroundColor = .green
        sv.addSubview(v1)
        v1.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        let v2 = UIView()
        v2.backgroundColor = .blue
        sv.addSubview(v2)
        v2.snp.makeConstraints { (make) in
            make.top.equalTo(v1.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        let v3 = UIView()
        v3.backgroundColor = .yellow
        sv.addSubview(v3)
        v3.snp.makeConstraints { (make) in
            make.top.equalTo(v2.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
    }
}
