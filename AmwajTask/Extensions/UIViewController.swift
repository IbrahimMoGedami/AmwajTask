//
//  UIViewController.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/16/23.
//

import UIKit

extension UIViewController {
    func setNavigationItem() {

//        let image: UIImage = UIImage.back
//        let leftButton = UIButton()
//        leftButton.setImage(image, for: .normal)
//        leftButton.backgroundColor = .mainWhite
//        let mySelectedAttributedTitle = NSAttributedString(string: "", attributes: [.font: UIFont.mainMedium(of: 16)])
//        leftButton.setAttributedTitle(mySelectedAttributedTitle, for: .normal)
//        leftButton.addTarget { [weak self] in
//            guard let self = self else {return}
//            self.popMe()
//        }
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
//        setShadowNav()
    }
    
    func dateFormater(date: TimeInterval, dateFormat: String, timeZone: Int? = nil) -> String {
        let dateText = Date(timeIntervalSince1970: date )
        let formater = DateFormatter()
        formater.timeZone = TimeZone(secondsFromGMT: timeZone ?? 0)
        formater.dateFormat = dateFormat
        return formater.string(from: dateText)
    }
    
    private func setShadowNav(){
        navigationController?.navigationBar.backgroundColor = .mainWhite
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.4
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        navigationController?.navigationBar.layer.shadowRadius = 1
//        navigationItem.setHidesBackButton(true, animated: true)

    }
}

