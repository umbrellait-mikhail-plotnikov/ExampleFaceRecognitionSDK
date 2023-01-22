//
//  MainLabel.swift
//  FaceDetection
//
//  Created by Plotnikov Mikhail on 22.01.2023.
//

import UIKit

class MainLabel: UILabel {
    init(text: String = "") {
        super.init(frame: .zero)
        self.text = text
        self.font = .boldSystemFont(ofSize: 34)
        self.textAlignment = .center
        self.numberOfLines = 0
        self.textColor = .black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
