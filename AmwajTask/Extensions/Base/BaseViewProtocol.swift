//
//  BaseViewProtocol.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/16/23.
//

import Foundation
import UIKit
import NVActivityIndicatorView

protocol BaseViewProtocol: AnyObject {
    var activityIndicatorView: NVActivityIndicatorView { get }
    func startLoading()
    func stopLoading()
    func showAlert(with message: String, title: AllertTitles)
}

extension BaseViewProtocol where Self: UIViewController {
    func showAlert(with message: String, title: AllertTitles) {
        // showAlertController(message: message)
        AlertViewHandler().showAlert(message: message, title: title)
    }
    
    func startLoading() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = UIScreen.main.bounds.center
        activityIndicatorView.startAnimating()
    }
    
    func stopLoading() {
        activityIndicatorView.removeFromSuperview()
        activityIndicatorView.stopAnimating()
    }
}
