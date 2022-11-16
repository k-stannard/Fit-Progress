//
//  AddRowFooterView.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/19/22.
//

import UIKit

class AddRowFooterView: UIView {
    
    let addRowButton = UIButton(type: .system)
    var title: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.title = title
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddRowFooterView {
    
    private func configure() {
        addRowButton.setTitle(title, for: .normal)
        addRowButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        addSubview(addRowButton)
    }
    
    private func layout() {
        addRowButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addRowButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addRowButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addRowButton.widthAnchor.constraint(equalToConstant: 150),
            addRowButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
