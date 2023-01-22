//
//  StartPresenter.swift
//  FaceDetection
//
//  Created by Plotnikov Mikhail on 22.01.2023.
//

import UIKit
import RealmSwift
import SFaceCompare

protocol StartViewDelegate {
    func presentCamera()
    func showErrorAlert()
    func updateImageView(image: UIImage?)
    func showSuccessScreen(user: User)
}

class StartPresenter {
    public var delegate: StartViewDelegate?
    public var authMode: AuthMode = .none
    public let realmDB = try! Realm()

    private var login: String?
    private var password: String?
    private var photo: UIImage? {
        didSet {
            delegate?.updateImageView(image: photo)
            if authMode == .signIn {
                loginExistUserByCamera()
            } else if authMode == .signUp {
                registerNewUserByCamera()
            }
        }
    }

    func set(login: String?) {
        self.login = login
    }

    func set(password: String?) {
        self.password = password
    }

    func set(photo: UIImage?) {
        self.photo = photo
    }

    func completeWithCamera() {
        delegate?.presentCamera()
    }

    func complete() {
        guard
            login != nil && login != "" ||
            password != nil && password != ""
        else {
            delegate?.showErrorAlert()
            return
        }
        if authMode == .signIn {
            loginExistUser()
        } else if authMode == .signUp {
            registerNewUser()
        }
    }

    private func registerNewUser() {
        let users = realmDB.objects(User.self)
        var unknownUser = true
        let user = User()
        user.uuid = UUID().uuidString
        user.login = login
        user.password = password
        if users.count == 0 {
            try! self.realmDB.write {
                self.realmDB.add(user)
            }
            delegate?.showSuccessScreen(user: user)
        }
        for user in users {
            guard
                let login = user.login,
                let password = user.password,
                self.login == login,
                self.password == password
            else { break }

            unknownUser = false
        }

        if unknownUser {
            try! self.realmDB.write {
                self.realmDB.add(user)
            }
            delegate?.showSuccessScreen(user: user)
        } else {
            delegate?.showErrorAlert()
        }
    }

    private func loginExistUser() {
        let users = realmDB.objects(User.self)
        var userFinded = false
        if users.count == 0 {
            delegate?.showErrorAlert()
        }
        for user in users {
            if let login = user.login,
               let password = user.password,
               self.login == login,
               self.password == password {
                userFinded = true
                delegate?.showSuccessScreen(user: user)
            }
        }
        if !userFinded {
            delegate?.showErrorAlert()
        }
    }

    private func registerNewUserByCamera() {
        guard let photo else { return }
        let users = realmDB.objects(User.self)
        var faceUnknown = true
        let user = User()
        user.photo = NSData(data: photo.pngData()!)
        user.uuid = UUID().uuidString
        var count = 0 {
            didSet {
                if count == 0 && faceUnknown {
                    try! self.realmDB.write {
                        self.realmDB.add(user)
                    }
                    delegate?.showSuccessScreen(user: user)
                } else if count == 0 {
                    delegate?.showErrorAlert()
                }
            }
        }
        if users.count == 0 {
            try! self.realmDB.write {
                self.realmDB.add(user)
            }
            delegate?.showSuccessScreen(user: user)
        }
        for user in users {
            count += 1
            guard
                let imageData = user.photo as? Data,
                let image = UIImage(data: imageData)
            else {
                count -= 1
                return
            }

            let compare = SFaceCompare(on: photo, and: image)
            compare.compareFaces { result in
                switch result {
                case .success:
                    faceUnknown = false
                case .failure:
                    break
                }
                count -= 1
            }
        }
    }

    private func loginExistUserByCamera() {
        guard let photo else { return }
        let users = realmDB.objects(User.self)
        var faceUnknown = true
        var count = 0 {
            didSet {
                if count == 0 && faceUnknown {
                    delegate?.showErrorAlert()
                }
            }
        }
        if users.count == 0 {
            delegate?.showErrorAlert()
        }
        for user in users {
            guard
                let imageData = user.photo as? Data,
                let image = UIImage(data: imageData)
            else {
                count -= 1
                return
            }

            let compare = SFaceCompare(on: photo, and: image)
            compare.compareFaces { [weak self] result in
                switch result {
                case .success:
                    self?.delegate?.showSuccessScreen(user: user)
                    faceUnknown = false
                case .failure:
                    break
                }
                count -= 1
            }
        }
    }
}
