//
//  CGsize+.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/16/23.
//

import UIKit

extension CGSize {
    init(all: CGFloat) {
        self.init(width: all, height: all)
    }
}

extension UIEdgeInsets {
    init(_ side: CGFloat) {
        self.init(top: side, left: side, bottom: side, right: side)
    }
    
    init(_ top: CGFloat, side: CGFloat) {
        self.init(top: top, left: side, bottom: top, right: side)
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
