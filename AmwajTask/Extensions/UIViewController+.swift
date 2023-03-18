//
//  UIViewController+.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import UIKit

extension UIViewController {
    
    func push(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func push(after: Double,_ vc: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func popMe() {
        navigationController?.popViewController(animated: true)
    }
    
    func showAlertController(title: String? = "", message: String?, selfDismissing: Bool = true, time: TimeInterval = 2) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.view.tintColor = .yellow
        alert.title = title
        alert.message = message
        
        alert.setValue(NSAttributedString(string: title ?? "", attributes: [.foregroundColor : UIColor.yellow]), forKey: "attributedTitle")
        alert.setValue(NSAttributedString(string: message ?? "", attributes: [.foregroundColor: UIColor.yellow, .font: UIFont.boldSystemFont(ofSize: 14)]), forKey: "attributedMessage")
        
        if !selfDismissing {
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        }
        
        present(alert, animated: true)
        
        if selfDismissing {
            Timer.scheduledTimer(withTimeInterval: time, repeats: false) { t in
                t.invalidate()
                alert.dismiss(animated: true)
            }
        }
    }
    
    
}

extension UIViewController {
    func alertPermission() {
        let alertController = UIAlertController(title: "Location Permission Required".localize, message: "Please enable location permissions in settings.".localize, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Settings".localize, style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        let cancelAction = UIAlertAction(title: "Cancel".localize, style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
