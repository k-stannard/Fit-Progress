//
//  FPTextField.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/16/22.
//

import UIKit

class FPTextField: UITextField {
    
    var rectBounds: CGFloat = 24
    
    convenience init(placeholder: String, alignment: NSTextAlignment, rectBounds: CGFloat) {
        self.init(frame: .zero)
        
        self.textAlignment = alignment
        self.placeholder = placeholder
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.rectBounds = rectBounds
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: rectBounds, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: rectBounds, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        .init(width: 44, height: 44)
    }
}
