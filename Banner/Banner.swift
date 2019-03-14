//
//  Banner.swift
//  Banner
//
//  Created by tongyi on 3/13/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class Banner: UIWindow {
    
    private var normalView: UIView!
    private var errorView: UIView!
    private var successView: UIView!
    
    // MARK: - Subviews in normalView
    private var messageLabel: UILabel!
    
    private static let shared = Banner()
    
    private var status = Status.NotShown
    private var bannerColor: UIColor {
        switch status {
        case .Normal:
            return .blue
        case .Failed:
            return .red
        case .Success:
            return .green
        case .NotShown:
            return .clear
        }
    }
    
    private var bannerHeight: CGFloat {
        if isNotchFeaturedIPhone() {
            switch status {
            case .Normal:
                return 26
            case .Failed:
                return 
            }
        } else {
            
        }
    }
    
    //Public class methods
    static func showNormal(_ message: String) {
        shared.showNormal(message)
    }
    
    static func showError(title: String, detail: String) {
        shared.showError(title: title, detail: detail)
    }
    
    static func showSuccess(title: String, detail: String) {
        shared.showSuccess(title: title, detail: detail)
    }
    
    
    //Private instance methods
    private func showNormal(_ message: String) {
        
    }
    
    private func showError(title: String, detail: String) {
        
    }
    
    private func showSuccess(title: String, detail: String) {
        
    }
    
    private override init(frame: CGRect) {
        let fixedFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        super.init(frame: fixedFrame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)

        if hitView == self {
            return nil
        } else {
            return hitView!
        }
    }
    
    func isNotchFeaturedIPhone() -> Bool {
        if #available(iOS 11, *) {
            if UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > CGFloat(0) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    private func setup() {
        
        //Normal View and subviews
        let normalView = UIView()
        self.normalView = normalView
        self.addSubview(normalView)
        
        
    }
    
    enum Status {
        case Normal //height: 24, Blue, tap to add buttons for canceling(searching.... )
        case Failed //height: 48, Red, Pull down for searching, slide up for dismissing(search failed, user can dismiss banner or searching again)
        case Success // height: 48, Green, tap and slide up for dismissing(search success, user can dismiss banner)
        case NotShown
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
    }
}
