////
////  Banner.swift
////  Banner
////
////  Created by Yi Tong on 3/8/19.
////  Copyright © 2019 Yi Tong. All rights reserved.
////
//
import UIKit
import SnapKit

class Banner: NSObject {

    // MARK: - Private properties
    private var bannerView: UIView!
    private var messageLabel: UILabel!
    private var bannerWindow: UIWindow!
    private var normalView: UIView!
    private var decisionView: UIView!
    private var errorView: UIView!
    private var searchingView: UILabel!
    private var errorTitleLabel: UILabel!
    private var errorDetailLabel: UILabel!
    
    private static let shared: Banner = Banner()
    
    private var breathSpeed: BreathSpeed = .Normal
    private var _height: CGFloat = UIApplication.shared.statusBarFrame.height + 10
    private let decisionViewHeight: CGFloat = 24
    private let topHeight: CGFloat = 60
    private var variableHeight: CGFloat {
        switch status {
        case .Normal:
            return height + topHeight
        case .Success, .Failed, .Undecided:
            return height + 36 + topHeight
        case .PullSearching:
            return height + 48 + topHeight
        case .NotShown:
            return topHeight
        }
    }

    // MARK: - Public properties
    static var isHidden: Bool { return shared.bannerWindow.isHidden }

    var height: CGFloat {
        get {
            if Banner.isNotchFeaturedIPhone() {
                return _height + 12
            } else {
                return _height
            }
        }

        set {
            _height = height
            bannerWindow.frame = CGRect(x: 0, y: -topHeight, width: UIScreen.main.bounds.width, height: variableHeight)
        }
    }

    var backgroundColor: UIColor = UIColor(red: 61/255.0, green: 131/255.0, blue: 220/255.0, alpha: 1) {
        didSet { bannerView.backgroundColor = backgroundColor }
    }
    var textColor: UIColor = .white {
        didSet { messageLabel.textColor = textColor }
    }
    var textFont: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet { messageLabel.font = textFont }
    }

    var message: String = "" {
        didSet { messageLabel.text = message }
    }

    var breathing: Bool = false {
        didSet {
            if breathing {
                startBreathing()
            } else {
                stopBreathing()
            }
        }
    }

    var status: Status = .Normal
    
    // MARK: - Object life cycle
    override init() {
        super.init()
        setup()
    }

    // MARK: - Actions
    @objc func bannerWindowTapped(tap: UITapGestureRecognizer) {

        if status == .Normal {
            status = .Undecided
            showDecisionView()
        } else if status == .Success {
            
        }
    }
    
    private func panChange(pan: UIPanGestureRecognizer) {
        let y = pan.translation(in: bannerWindow).y
        
        //设定最大位移
        if bannerWindow.frame.maxY > height + 36 + topHeight * 0.5 {
            status = .Normal
            failBecomeNormal()
        }
    }
    
    private func failBecomeNormal() {
        bannerWindow.frame = CGRect(x: 0, y: -topHeight, width: UIScreen.main.bounds.width, height: variableHeight)
        
    }
    
    private func panEnd(pan: UIPanGestureRecognizer) {
        
    }
    
    @objc func bannerWindowPanned(pan: UIPanGestureRecognizer) {
        if status == .Failed {
            switch pan.state {
            case .changed:
                panChange(pan: pan)
            case .ended, .cancelled, .failed, .possible:
                panEnd(pan: pan)
            default: break
//            case .changed:
//                //如果向上滑，上移
//
//                //设定最大移动距离
//                if bannerWindow.frame.maxY > errorView.bounds.height + topHeight * 0.75 {
//                    return
//                }
//
//                //设定摩擦系数
//                let fraction = 0.5 // 0无摩擦， 1满摩擦
//                if
//
//                if bannerWindow.frame.maxY >
//                //如果向下滑，下移显示searchingView。超过searchingView高度，状态变为Normal
//            case .cancelled, .ended:
//                //如果向上滑动距离小于errorView高度的一半，弹回。若大于，关闭Banner。
//                //如果向下滑动距离小于searchingView高度，弹回。
//                print("end")
//            default:
//                print("Default")
            }
        }
        
        pan.setTranslation(CGPoint.zero, in: bannerWindow)
    }
    
    @objc func leaveButtonTapped() {
        status = .NotShown
        hide()
    }
    
    @objc func stayButtonTapped() {
        status = .Normal
        hideDecisionView()
    }

    // MARK: - Public functions
    //Normal
    static func show(_ message: String) {
        shared.show(message)
    }

    static func show() {
        shared.show()
    }

    static func hide() {
        shared.hide()
    }
    
    //Error
    static func showError(title: String, detail: String) {
        shared.showError(title: title, detail: detail)
    }

    static func setMessage(_ message: String) {
        shared.setMessage(message)
    }

    // MARK: - Private function
    private func showError(title: String, detail: String) {
        errorTitleLabel.text = title
        errorDetailLabel.text = detail
        errorView.isHidden = false
        
        status = .Failed
        bannerWindow.frame = CGRect(x: 0, y: -topHeight, width: UIScreen.main.bounds.width, height: variableHeight)
        bannerWindow.layoutIfNeeded()
    }
    
    private func show(_ message: String) {
        self.message = message
        show()
    }
    
    private func show() {
        status = .Normal
        self.bannerWindow.frame = CGRect(x: 0, y: -topHeight, width: UIScreen.main.bounds.width, height: variableHeight)
        UIView.animate(withDuration: 0.25 , animations: {
            self.bannerWindow.isHidden = false
            self.bannerWindow.layoutIfNeeded()
        })
    }

    private func hide() {
        status = .NotShown
        self.bannerWindow.frame = CGRect(x: 0, y: -topHeight, width: UIScreen.main.bounds.width, height: variableHeight)
        UIView.animate(withDuration: 0.25, animations: {
            self.bannerWindow.layoutIfNeeded()
        }) { _ in
            self.hideDecisionView()
            self.bannerWindow.isHidden = true
        }

    }

    private func setMessage(_ message: String) {
        self.message = message
    }

    private func startBreathing() {
        let layer = messageLabel.layer
        let group = CAAnimationGroup()
        let anim1 = CABasicAnimation(keyPath: "opacity")
        let anim2 = CABasicAnimation(keyPath: "opacity")

        anim1.fromValue = 0
        anim1.toValue = 1
        anim1.duration = breathSpeed.rawValue * 0.5
        anim1.beginTime = 0

        anim2.fromValue = 1
        anim2.toValue = 0
        anim2.duration = breathSpeed.rawValue * 0.5
        anim2.beginTime = breathSpeed.rawValue * 0.5

        group.animations = [anim1, anim2]
        group.repeatCount = Float.infinity
        group.duration = breathSpeed.rawValue

        layer.add(group, forKey: nil)
    }

    private func stopBreathing() {

    }

    // MARK: - Private Helper functions
    private func setup() {

        //Banner window
        let w = UIWindow(frame: CGRect(x: 0, y: -topHeight, width: UIScreen.main.bounds.width, height: 0))
        w.windowLevel = .alert + 1
        bannerWindow = w
        
        let contentV = UIView()
        contentV.backgroundColor = status.color
        contentV.translatesAutoresizingMaskIntoConstraints = false
        normalView = contentV
        w.addSubview(contentV)

        //Banner view
        let v = UIView()
        contentV.addSubview(v)
        bannerView = v

        //Message label in banner view
        let label = UILabel()
        label.textColor = textColor
        label.text = message
        label.textAlignment = .center
        label.font = textFont
        v.addSubview(label)
        messageLabel = label

        breathing = true

        //Layout
        contentV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().labeled("1")
        }
        
        bannerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(topHeight).labeled("2")
            make.left.right.equalToSuperview().labeled("3")
            make.height.equalTo(height).priority(.low).labeled("4")
        }

        if Banner.isNotchFeaturedIPhone() {
            messageLabel.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview().labeled("5")
                make.bottom.equalToSuperview().offset(-4).labeled("6")
            }
        } else {
            messageLabel.snp.makeConstraints { (make) in
                make.edges.equalToSuperview().labeled("7")
            }
        }
        
        decisionView = createDecisionView()
//        errorView = createErrorView()
        
        bannerWindow.frame = CGRect(x: 0, y: -topHeight, width: UIScreen.main.bounds.width, height: variableHeight)
        bannerWindow.layoutIfNeeded()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(bannerWindowTapped))
        bannerWindow.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(bannerWindowPanned))
        bannerWindow.addGestureRecognizer(pan)
    }
    
    private func createErrorView() -> UIView {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = Status.Failed.color
        normalView.addSubview(v)
        
        let searchingV = UILabel()
        searchingV.text = "Searching..."
        searchingV.textColor = .white
        searchingV.font = textFont
        searchingV.textAlignment = .center
        searchingView = searchingV
        v.addSubview(searchingV)
        
        let infoView = UIView()
        v.addSubview(infoView)
        
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = textFont
        titleLabel.textAlignment = .center
        errorTitleLabel = titleLabel
        infoView.addSubview(titleLabel)
        
        let detailLabel = UILabel()
        detailLabel.textColor = .white
        detailLabel.font = textFont
        detailLabel.textAlignment = .center
        errorDetailLabel = detailLabel
        infoView.addSubview(detailLabel)
        
        //Layout
        v.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        searchingV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(v.snp.top).offset(topHeight)
        }
        
        infoView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchingV.snp.bottom)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-6)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(detailLabel.snp.top).offset(-10)
        }
        
        return v
    }

    private func createDecisionView() -> UIView {
        let v = UIView()
        v.isHidden = true
        normalView.addSubview(v)
        
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: textFont]
        
        let stayButton = UIButton()
        stayButton.setAttributedTitle(NSAttributedString(string: "Stay", attributes: attributes), for: .normal)
        stayButton.alpha = 0
        stayButton.addTarget(self, action: #selector(stayButtonTapped), for: .touchUpInside)
        v.addSubview(stayButton)
        
        let leaveButton = UIButton()
        leaveButton.setAttributedTitle(NSAttributedString(string: "Leave", attributes: attributes), for: .normal)
        leaveButton.alpha = 0
        leaveButton.addTarget(self, action: #selector(leaveButtonTapped), for: .touchUpInside)
        v.addSubview(leaveButton)
        
        v.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().labeled("8")
            make.top.equalTo(bannerView.snp.bottom).labeled("9")
        }
        
        leaveButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().labeled("10")
            make.centerX.equalToSuperview().multipliedBy(0.5).labeled("11")
        }
        
        stayButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().labeled("12")
            make.centerX.equalToSuperview().multipliedBy(1.5).labeled("13")
        }
        
        return v
    }

    private func showDecisionView() {
        decisionView.isHidden = false
        self.bannerWindow.frame = CGRect(x: 0, y: -topHeight, width: self.bannerWindow.bounds.width, height: self.variableHeight)
        UIView.animate(withDuration: 0.25) {
            self.bannerWindow.layoutIfNeeded()
            self.decisionView.subviews.forEach { $0.alpha = 1 }
        }
    }
    
    private func hideDecisionView() {
        self.bannerWindow.frame = CGRect(x: 0, y: -topHeight, width: self.bannerWindow.bounds.width, height: self.variableHeight)
        UIView.animate(withDuration: 0.25, animations: {
            self.bannerWindow.layoutIfNeeded()
            self.decisionView.subviews.forEach { $0.alpha = 0 }
        }) { _ in self.decisionView.isHidden = true}
    }
    
    // MARK: - Some internal structures
    enum BreathSpeed: TimeInterval {
        case Normal = 2.5 //Means we'll cost 4 seconds to finish a breath cycle
        case Slow = 6
        case Rapid = 1
    }

    enum Status {
        case Normal //height: 24, Blue, tap to add buttons for canceling(searching.... )
        case Failed //height: 48, Red, Pull down for searching, slide up for dismissing(search failed, user can dismiss banner or searching again)
        case Success // height: 48, Green, tap and slide up for dismissing(search success, user can dismiss banner)
        case Undecided //height: 48, Blue, click buttons to decide stay or leave(searching...)
        case PullSearching //height: 64, Red, tap to become Normal status(searching...)
        case NotShown
        
        var color: UIColor {
            switch self {
            case .Normal, .Undecided:
                return UIColor(red: 61, green: 131, blue: 220)
            case .Failed, .PullSearching:
                return .red
            case .Success:
                return .green
            case .NotShown:
                return .clear
            }
        }
    }

    // MARK: - Other functions
    class func isNotchFeaturedIPhone() -> Bool {
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
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
    }
}
