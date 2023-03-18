//
//  GestureRecognizer+.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/15/23.
//

import UIKit

class BindableGestureRecognizer: UITapGestureRecognizer {
    private var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }

    @objc private func execute() {
        action()
    }
}
