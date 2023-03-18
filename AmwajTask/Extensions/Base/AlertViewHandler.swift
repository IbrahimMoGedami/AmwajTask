//
//  AlertViewHandler.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/16/23.
//

import Foundation
import UIKit

enum Theme {
    case success
    case warning
    case error
}

enum AllertTitles {
    case error
    case success
    case warning
    
    var localize: String {
        switch self {
        case .error:
            return "Error".localize
        case .success:
            return "Success".localize
        case .warning:
            return "Warning".localize
        }
    }
    
    var theme: Theme {
        switch self {
        case .error:
            return .error
        case .success:
            return .success
        case .warning:
            return .warning
        }
    }
}


class AlertView: UIView {
    
    private let imageView = UIImageView()
    private let titleLable = UILabel()
    private let messageLable = UILabel()
    
    private var message: String
    private var title: AllertTitles
    
    init(message: String, title: AllertTitles) {
        self.message = message
        self.title = title
        super.init(frame: .zero)
        setup()
    }
    
    private func setup() {
        switch title {
        case .success:
            imageView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.737254902, blue: 0.2392156863, alpha: 1)
            titleLable.textColor = .mainColor
            backgroundColor = .white
            imageView.image = #imageLiteral(resourceName: "success").withRenderingMode(.alwaysTemplate)
        case .warning:
            imageView.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.8509803922, blue: 0.1411764706, alpha: 1)
            titleLable.textColor = #colorLiteral(red: 0.9843137255, green: 0.8509803922, blue: 0.1411764706, alpha: 1)
            backgroundColor = .white
            imageView.image = #imageLiteral(resourceName: "error").withRenderingMode(.alwaysTemplate)
        case .error:
            imageView.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.168627451, blue: 0.1529411765, alpha: 1)
            titleLable.textColor = #colorLiteral(red: 0.8784313725, green: 0.168627451, blue: 0.1529411765, alpha: 1)
            backgroundColor = .white
            imageView.image = #imageLiteral(resourceName: "Info").withRenderingMode(.alwaysTemplate)
        }
        
        messageLable.textColor = .gray
        titleLable.text = title.localize
        messageLable.numberOfLines = 2
        messageLable.text = message
        imageView.tintColor = .white
        // layer.cornerRadius = 3
        // layer.applySketchShadow(color: #colorLiteral(red: 0.2, green: 0, blue: 0, alpha: 0.19), alpha: 1, x: 0, y: 2, blur: 9, spread: 0)
        
        let swipeToTop = UISwipeGestureRecognizer(target: self, action: #selector(handelGesture(_:)))
        swipeToTop.direction = .up
        
        addGestureRecognizer(swipeToTop)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.closeMe()
        }
    }
    
    @objc
    private func handelGesture(_ sender: UISwipeGestureRecognizer) {
        closeMe()
    }
    
    private func closeMe() {
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = .init(translationX: 0, y: -1000)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    fileprivate func layout() {
        // let view = UIView()
        // view.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30 / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            // imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.font = UIFont(name: "", size: 16)
        addSubview(titleLable)
        NSLayoutConstraint.activate([
            titleLable.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            titleLable.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0),
            titleLable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        messageLable.translatesAutoresizingMaskIntoConstraints = false
        messageLable.font = UIFont(name: "", size: 12)
        addSubview(messageLable)
        NSLayoutConstraint.activate([
            messageLable.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            messageLable.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 2),
            messageLable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        transform = .init(translationX: 0, y: -1000)
        alpha = 1
        
        UIView.animate(withDuration: 1) {
            self.transform = .identity
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AlertViewHandler {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var window = appDelegate.window!
    
    func showAlert(message: String, title: AllertTitles) {
        
        // let safeAreaTop = UIApplication.shared.windows
        // .filter{ $0.isKeyWindow }.first?.safeAreaInsets.top ?? 0
        
        let view = AlertView(message: message, title: title)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.applySketchShadow()
        window.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: window.topAnchor, constant: 0),
            view.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: 0),
            view.heightAnchor.constraint(equalToConstant: 80 + 70)
        ])
        view.layout()
    }
}
