//
//  SelectWorkoutCell.swift
//  fitProgress
//
//  Created by Koty Stannard on 9/2/22.
//

import UIKit

class SelectWorkoutCell: UITableViewCell {
    
    static let reuseId = "selectWorkoutCell"
    
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectWorkoutCell {
    
    private func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select Workout"
    }
    
    private func layout() {
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
