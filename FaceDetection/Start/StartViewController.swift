//
//  ViewController.swift
//  FaceDetection
//
//  Created by Plotnikov Mikhail on 21.01.2023.
//

import UIKit
import SnapKit

class StartViewController: UIViewController {
    private let scrollView = UIScrollView()

    private let headerDevider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray

        return view
    }()

    private lazy var contentView: UIView = {
        let view = UIView()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        return view
    }()

    private lazy var mainLabel = MainLabel(text: "Super app using FaceRecognitionSDK")
    private lazy var stateLabel = MainLabel()

    private lazy var authTypeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.addArrangedSubview(stateLabel)
        stack.addArrangedSubview(authByCameraButton)

        return stack
    }()

    private let mainImageView: UIImageView = {
        let image = UIImage(named: "mainImage")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var signInButton: MainButton = {
        let button = MainButton(text: "Sign In", borderIsNeed: true)
        button.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)

        return button
    }()

    private lazy var signUpButton: MainButton = {
        let button = MainButton(text: "Sign Up", borderIsNeed: true)
        button.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)

        return button
    }()

    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.addArrangedSubview(signInButton)
        stack.addArrangedSubview(signUpButton)
        stack.backgroundColor = .black
        stack.layer.cornerRadius = 4
        stack.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
        stack.isLayoutMarginsRelativeArrangement = true

        return stack
    }()

    private lazy var loginLabel = MainLabel(text: "Login:")
    private lazy var passwordLabel = MainLabel(text: "Password:")

    private lazy var loginTextField = MainTextField(padding: .init(top: 5, left: 5, bottom: 5, right: 5))
    private lazy var passwordTextField = MainTextField(padding: .init(top: 5, left: 5, bottom: 5, right: 5))

    private lazy var loginStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4

        stack.addArrangedSubview(loginLabel)
        stack.addArrangedSubview(loginTextField)
        loginLabel.textAlignment = .left

        return stack
    }()

    private lazy var passwordStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4

        stack.addArrangedSubview(passwordLabel)
        stack.addArrangedSubview(passwordTextField)
        passwordLabel.textAlignment = .left

        return stack
    }()

    private lazy var authByCameraButton: MainButton = {
        let button = MainButton(text: "By Camera")
        button.addTarget(self, action: #selector(authByCamTapped), for: .touchUpInside)

        return button
    }()

    private lazy var nextButton: MainButton = {
        let button = MainButton(text: "Complete")
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

        return button
    }()

    public var presenter: StartPresenter?

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerKeyboardNotifications()
        presenter?.delegate = self
    }

    deinit {
        removeKeyboardNotifications()
    }

    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews(scrollView, buttonStack)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            mainLabel,
            authTypeStack,
            headerDevider,
            mainImageView,
            loginStack,
            passwordStack,
            nextButton
        )

        scrollView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(buttonStack.snp.top)
        }

        buttonStack.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview().inset(32)
        }

        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalTo(view)
        }

        mainLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(16)
        }

        mainImageView.snp.makeConstraints {
            $0.width.height.equalTo(256)
            $0.top.equalTo(mainLabel.snp.bottom).offset(64)
            $0.centerX.bottom.equalToSuperview()
        }
    }

    private func updateUIafterTap() {
        guard
            let mode = presenter?.authMode,
            mode == .none
        else { return }
        mainLabel.snp.removeConstraints()
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(-128)
            $0.left.right.equalToSuperview().inset(16)
        }
        mainLabel.isHidden = true

        mainImageView.snp.removeConstraints()
        mainImageView.snp.makeConstraints {
            $0.width.height.equalTo(128)
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().inset(16)
        }
        mainImageView.layer.cornerRadius = 128 / 2
        mainImageView.clipsToBounds = true

        authTypeStack.snp.makeConstraints {
            $0.left.equalTo(mainImageView.snp.right).offset(16)
            $0.right.equalToSuperview().inset(16)
            $0.centerY.equalTo(mainImageView.snp.centerY)
        }

        headerDevider.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(16)
            $0.height.equalTo(1)
            $0.left.right.equalToSuperview()
        }
        headerDevider.alpha = 0

        loginStack.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(32)
        }

        passwordStack.snp.makeConstraints {
            $0.top.equalTo(loginStack.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(32)
        }

        nextButton.snp.makeConstraints {
            $0.top.equalTo(passwordStack.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview()
        }

        loginStack.alpha = 0
        passwordStack.alpha = 0

        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.loginStack.alpha = 1
            self.passwordStack.alpha = 1
            self.headerDevider.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

    @objc
    private func nextTapped(sender: UIButton!) {
        presenter?.set(login: loginTextField.text)
        presenter?.set(password: passwordTextField.text)
        presenter?.complete()
    }

    @objc
    private func authByCamTapped(sender: UIButton!) {
        presenter?.completeWithCamera()
    }

    @objc
    private func signInTapped(sender: UIButton!) {
        updateUIafterTap()
        stateLabel.text = "Sign In"
        signInButton.changeState(isTapped: true)
        signUpButton.changeState(isTapped: false)
        presenter?.authMode = .signIn
    }

    @objc
    private func signUpTapped(sender: UIButton!) {
        updateUIafterTap()
        stateLabel.text = "Sign Up"
        signInButton.changeState(isTapped: false)
        signUpButton.changeState(isTapped: true)
        presenter?.authMode = .signUp
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height - buttonStack.bounds.size.height
        scrollView.contentInset = contentInset
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
    }
}

extension StartViewController: StartViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func showSuccessScreen(user: User) {
        let vc = SuccessViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }

    func updateImageView(image: UIImage?) {
        if let image {
            mainImageView.image = image
        } else {
            mainImageView.image = UIImage(named: "mainImage")
        }
    }

    func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            imagePickerController.cameraDevice = .front
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }

    func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Input data is invalid", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        self.dismiss(animated: true, completion: nil)
        presenter?.set(photo: image.updateImageOrientionUpSide())
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        presenter?.set(photo: nil)
    }
}

extension UIView {
    public func addSubviews(_ arrayViews: UIView...) {
        for view in arrayViews {
            self.addSubview(view)
        }
    }
}

extension UIImage {

    func updateImageOrientionUpSide() -> UIImage? {
        if self.imageOrientation == .up {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        }
        UIGraphicsEndImageContext()
        return nil
    }
}
