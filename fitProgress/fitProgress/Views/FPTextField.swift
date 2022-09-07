//
//  FPTextField.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/16/22.
//

import UIKit

class FPTextField: UITextField {
    
    var useTextRect = true
    
    convenience init(placeholder: String, alignment: NSTextAlignment, useTextRect: Bool) {
        self.init(frame: .zero)
        
        self.useTextRect = useTextRect
        self.textAlignment = alignment
        self.placeholder = placeholder
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
//        self.layer.borderWidth = borderWidth
//        self.layer.cornerRadius = cornerRadius
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if useTextRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        return bounds.insetBy(dx: 0, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        if useTextRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        return bounds.insetBy(dx: 0, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        .init(width: 44, height: 44)
    }
}
