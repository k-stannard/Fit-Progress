//
//  AddWorkoutTableViewCell.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/16/22.
//

import UIKit

class AddWorkoutTableViewCell: UITableViewCell {
    
    static let reuseid = "addWorkoutCell"
    
    let textField = AddWorkoutTextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddWorkoutTableViewCell {
    
    func setup() {
        contentView.isUserInteractionEnabled = true
        contentView.addSubview(textField)
    }
    
    func layout() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
