//
//  EnterViewController.swift
//  AutmnSchool24
//
//  Created by Emil Shpeklord on 20.07.2024.
//

import UIKit
import OSLog

final class EnterViewController: UIViewController {
    private let logger = Logger(subsystem: "AutmnSchool24", category: "EnterViewController")
    private let patternPassword = /^(?=.+[A-Z])(?=.+[0-9])(?=.+[.,?!():;]).{8,}$/
    private struct Constants {
        static let cornerRadiusTextField: CGFloat = 15
        static let cornerRadiusButton: CGFloat = 10
        static let customSpacing: CGFloat = 40
        static let leadingInset: CGFloat = 22
    }
    
    private lazy var loginField: UITextField = {
        let field = UITextField()
        field.layer.masksToBounds = true
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = Constants.cornerRadiusTextField
        field.placeholder = "Login"
        return field
    }()
    
    private lazy var passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.layer.masksToBounds = true
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = Constants.cornerRadiusTextField
        field.addTarget(self, action: #selector(handlePasswordChange), for: .editingChanged)
        return field
    }()
    
    private lazy var loginTitle: UILabel = {
        let label = UILabel()
        label.text = "Enter your login and password"
        label.textAlignment = .center
        label.textColor = .styleruSubtitle
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.customSpacing
        return stackView
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.styleruGray, for: .highlighted)
        button.layer.cornerRadius = Constants.cornerRadiusButton
        button.addTarget(self, action: #selector(moveNextView), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.styleruBorderGray.cgColor
        button.backgroundColor = .styleruLightGray
        return button
    }()
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - Handlers

private extension EnterViewController {
    @objc func handlePasswordChange() {
        guard let password = passwordField.text else {
            return
        }
        if checkPasswordCorrect(password) {
            passwordField.layer.borderWidth = 0
            passwordField.layer.borderColor = nil
            
        } else {
            passwordField.layer.borderWidth = 1
            passwordField.layer.borderColor = UIColor.red.cgColor
        }
    }
}

// MARK: - Check fields

private extension EnterViewController {
    func checkFields() -> Bool {
        guard
            let login = loginField.text,
            let password = passwordField.text,
            !login.isEmpty,
            !password.isEmpty
        else {
            logger.info("Check fields not correct!")
            return false
        }
        return checkPasswordCorrect(password)
    }
    
    func checkPasswordCorrect(_ password: String) -> Bool {
        password.contains(patternPassword)
    }
}

// MARK: - Move next view
    
private extension EnterViewController {
    @objc func moveNextView() {
        if checkFields() {
            logger.info("Registartion successful!")
            dismiss(animated: true)
        }
    }
}

// MARK: - SetupUI

private extension EnterViewController {
    func setupUIMainStackView() {
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(loginField)
        mainStackView.addArrangedSubview(passwordField)
        
        mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: loginTitle.bottomAnchor, constant: 40).isActive = true
        
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leadingInset).isActive = true
    }
    
    func setupUILoginButton() {
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.customSpacing).isActive = true
    }
    
    func setupUILoginTitle() {
        view.addSubview(loginTitle)
        loginTitle.translatesAutoresizingMaskIntoConstraints = false
        loginTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        loginTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leadingInset).isActive = true
    }
    
    func setupUIView() {
        view.backgroundColor = .black
    }
    
    func setupUI() {
        setupUIView()
        setupUILoginButton()
        setupUILoginTitle()
        setupUIMainStackView()
        
    }
}

extension EnterViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}
