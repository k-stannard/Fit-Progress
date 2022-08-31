//
//  FPTextField.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/16/22.
//

import UIKit

class FPTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 24, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 24, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        .init(width: 0, height: 44)
    }
}
