//
//  LogExerciseCell.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/31/22.
//

import UIKit

class LogExerciseCell: UITableViewCell {
    
    static let reuseid = "LogExerciseCell"
    
    let nameLabel = UILabel()
    let weightTextField = FPTextField(placeholder: "Lb", alignment: .center, useTextRect: false)
    let setsTextField = FPTextField(placeholder: "Sets", alignment: .center, useTextRect: false)
    let repsTextField = FPTextField(placeholder: "Reps", alignment: .center, useTextRect: false)

    private let textFieldStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LogExerciseCell {
    
    func setup() {
        nameLabel.numberOfLines = 2
        
        textFieldStackView.axis = .horizontal
        textFieldStackView.spacing = 8
        textFieldStackView.distribution = .fillEqually
    }
    
    func layout() {
        [weightTextField, setsTextField, repsTextField].forEach { view in
            view.font = UIFont.systemFont(ofSize: 15)
            textFieldStackView.addArrangedSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        contentView.addSubview(textFieldStackView)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            textFieldStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textFieldStackView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 12),
            textFieldStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            textFieldStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
