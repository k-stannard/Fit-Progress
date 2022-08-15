//
//  EmptyStateView.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/15/22.
//

import UIKit

class EmptyStateView: UIView {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: 200, height: 200)
//    }
}

extension EmptyStateView {
    
    func style() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 100)
        let image = UIImage(systemName: "pencil", withConfiguration: config)
        imageView.image = image
        imageView.tintColor = .secondaryLabel
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "No Saved Workouts"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        titleLabel.textColor = .secondaryLabel
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = "Add a workout to start tracking your progress!"
        messageLabel.textColor = .secondaryLabel
        messageLabel.numberOfLines = 0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
    }
    
    func layout() {
        [imageView, titleLabel, messageLabel].forEach { view in
            stackView.addArrangedSubview(view)
        }
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
