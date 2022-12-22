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
    let weightTextField = FPTextField(placeholder: "Lb", alignment: .center, rectBounds: 0)
    let repsTextField = FPTextField(placeholder: "Reps", alignment: .center, rectBounds: 2)
    let rirTextField = FPTextField(placeholder: "RIR", alignment: .center, rectBounds: 4)

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
        [weightTextField, repsTextField, rirTextField].forEach { textField in
            textField.font = UIFont.systemFont(ofSize: 15)
            textField.keyboardType = .numberPad
            textFieldStackView.addArrangedSubview(textField)
            textField.translatesAutoresizingMaskIntoConstraints = false
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
    
    func configureCellTextFields(with delegate: UITextFieldDelegate, indexPath: IndexPath) {
        weightTextField.delegate = delegate
        repsTextField.delegate = delegate
        rirTextField.delegate = delegate
        
        weightTextField.tag = 100 * indexPath.row
        repsTextField.tag = 100 * indexPath.row + 1
        rirTextField.tag = 100 * indexPath.row + 2
    }
}
