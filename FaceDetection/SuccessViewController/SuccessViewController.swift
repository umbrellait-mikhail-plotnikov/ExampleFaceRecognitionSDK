//
//  SuccessViewController.swift
//  FaceDetection
//
//  Created by Plotnikov Mikhail on 22.01.2023.
//

import UIKit
import RealmSwift

class SuccessViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: "mainImage")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var loginLabel = MainLabel(text: user.login ?? "Unknown person")

    private let user: User
    private let realm = try! Realm()

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        if user.login == nil || user.login == "" {
            showAlertWithTextField()
        }
        setupUI()
        guard
            let imageData = user.photo as? Data,
            let image = UIImage(data: imageData)
        else {
            self.showPhotoRequest()
            return
        }
        imageView.image = image
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews(loginLabel, imageView)

        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(128)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(256)
        }

        imageView.layer.cornerRadius = 128
        imageView.clipsToBounds = true

        loginLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(16)
        }
    }

    private func showAlertWithTextField() {
        let alert = UIAlertController(
            title: "Oooops.. You don't have a username and password",
            message: "",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = "Enter login:"
        }

        alert.addTextField { textField in
            textField.placeholder = "Enter password:"
        }

        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            if let loginField = alert?.textFields?[0],
               let loginText = loginField.text,
               !loginText.isEmpty,
               let passwordField = alert?.textFields?[1],
               let passwordText = passwordField.text,
               !passwordText.isEmpty {
                try! self.realm.write { [weak self] in
                    self?.user.login = loginText
                    self?.user.password = passwordText
                }
            }
        }))

        self.present(alert, animated: true, completion: { [weak self] in
            if self?.user.photo == nil {
                self?.showPhotoRequest()
            }
        })
    }

    private func showPhotoRequest() {

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
