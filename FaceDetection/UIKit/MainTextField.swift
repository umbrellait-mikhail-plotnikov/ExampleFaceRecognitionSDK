//
//  MainTextField.swift
//  FaceDetection
//
//  Created by Plotnikov Mikhail on 21.01.2023.
//

import UIKit

class MainTextField: UITextField {
    private let padding: UIEdgeInsets

    init(padding: UIEdgeInsets = .zero) {
        self.padding = padding
        super.init(frame: .zero)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.textColor = .black
        self.font = .boldSystemFont(ofSize: 28)
        self.layer.cornerRadius = 4
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: padding)
    }
}
