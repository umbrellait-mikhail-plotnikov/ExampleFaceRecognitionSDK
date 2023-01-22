//
//  MainButton.swift
//  FaceDetection
//
//  Created by Plotnikov Mikhail on 22.01.2023.
//

import UIKit

class MainButton: UIButton {
    init(text: String = "", borderIsNeed: Bool = false) {
        super.init(frame: .zero)
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 24)
        self.titleLabel?.textColor = .white
        self.backgroundColor = .black
        self.layer.cornerRadius = 4
        if borderIsNeed {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.white.cgColor
        } else {
            self.layer.borderWidth = 0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeState(isTapped: Bool) {
        UIView.animate(withDuration: 0.3) {
            if isTapped {
                self.setTitleColor(.black, for: .normal)
                self.backgroundColor = .white
                self.layer.borderColor = UIColor.black.cgColor
            } else {
                self.setTitleColor(.white, for: .normal)
                self.backgroundColor = .black
                self.layer.borderColor = UIColor.white.cgColor
            }
        }
    }
}
