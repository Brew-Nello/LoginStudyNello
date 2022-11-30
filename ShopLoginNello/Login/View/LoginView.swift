//
//  LoginView.swift
//  ShopLoginNello
//
//  Created by nello on 2022/11/16.
//

import UIKit

final class LoginView: UIView {
    
    // MARK: - UI
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "login")!
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = StatusType.intro.title
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "꽃피는시절 비회원 주문 및 SNS 계정(페이스북/네이버 등)으로 로그인하여 주문하신 경우, '주문 페이지 바로가기'를 이용해주세요."
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let idIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.circle.fill")!
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    let idTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "꽃피는 시절 아이디"
        return textField
    }()
    
    let idTextFieldLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    let passwordIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "password_icon")!
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "비밀번호"
        return textField
    }()
    
    let passwordTextFieldLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    let termInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        let text = "자동 로그인 약관에 동의"
        let textColor = Colors.primary_color
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: textColor, range: (text as NSString).range(of: "자동 로그인 약관"))
        attributedString.addAttribute(.font, value: font, range: (text as NSString).range(of: text))
        label.attributedText = attributedString
        return label
    }()
    var termInfoLabelHeightConstraint: NSLayoutConstraint?
    
    lazy var termCheckButton: UIButton = {
        let checked_normal = UIImage(named: "checked_normal")!
        let unchecked_normal = UIImage(named: "unchecked_normal")!
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(unchecked_normal, for: .normal)
        button.setImage(checked_normal, for: .selected)
        return button
    }()
    var termInfoCheckButtonHeightConstraint: NSLayoutConstraint?
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = Colors.disable_color
        button.isEnabled = false
        return button
    }()
    
    let findIdPasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("아이디&비밀번호 찾기", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return button
    }()
    
    let autoLoginTermButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("자동 로그인 연결 약관", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        button.backgroundColor = Colors.disable_color
        button.isHidden = true
        return button
    }()
    var autoLoginTermButtonBottomConstraint: NSLayoutConstraint?
    
    let loadingIndicatorView: UIActivityIndicatorView = {
        let loadingIndicatorView = UIActivityIndicatorView()
        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicatorView.color = .white
        return loadingIndicatorView
    }()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureTextFieldKeyboardType()
        addSubviews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    private func configure() {
        backgroundColor = .white
    }
    
    private func configureTextFieldKeyboardType() {
        idTextField.keyboardType = .namePhonePad
        passwordTextField.keyboardType = .namePhonePad
        passwordTextField.isSecureTextEntry = true
    }
    
    // MARK: - Actions
    /// 아이디, 비밀번호, 약관, 로그인 버튼, 찾기 활성화/비활성화
    func setEnableViews(isEnabled: Bool) {
        idTextField.isUserInteractionEnabled = isEnabled
        passwordTextField.isUserInteractionEnabled = isEnabled
        termCheckButton.isUserInteractionEnabled = isEnabled
        loginButton.isUserInteractionEnabled = isEnabled
        findIdPasswordButton.isUserInteractionEnabled = isEnabled
        
        let alpha = isEnabled ? 1 : 0.3
        idIconImageView.alpha = alpha
        idTextField.alpha = alpha
        idTextFieldLineView.alpha = alpha
        passwordIconImageView.alpha = alpha
        passwordTextField.alpha = alpha
        passwordTextFieldLineView.alpha = alpha
        termInfoLabel.alpha = alpha
        termCheckButton.alpha = alpha
        loginButton.alpha = alpha
        findIdPasswordButton.alpha = alpha
    }
    
    /// 로그인 성공 시 약관 label과 button 안보이게 처리
    func hiddenTermViews() {
        termInfoLabelHeightConstraint?.constant = 0
        termInfoCheckButtonHeightConstraint?.constant = 0
    }
    
    /// 로그인 성공 시 자동 로그인 약관 버튼 보이게 처리
    func showAutoLoginView() {
        autoLoginTermButton.isHidden = false
    }
    
    // MARK: - Layouts
    func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(mainImageView)
        
        contentView.addSubview(statusLabel)
        contentView.addSubview(infoLabel)
        
        contentView.addSubview(idIconImageView)
        contentView.addSubview(idTextField)
        contentView.addSubview(idTextFieldLineView)
        
        contentView.addSubview(passwordIconImageView)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(passwordTextFieldLineView)
        
        contentView.addSubview(termInfoLabel)
        contentView.addSubview(termCheckButton)
        
        contentView.addSubview(loginButton)
        contentView.addSubview(findIdPasswordButton)
        contentView.addSubview(autoLoginTermButton)
        
        addSubview(loadingIndicatorView)
    }
    
    func setLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let contentViewHeightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        contentViewHeightConstraint.priority = UILayoutPriority(rawValue: 500)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentViewHeightConstraint
        ])
        
        let constraint = mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 200)
        constraint.priority = UILayoutPriority(rawValue: 250)
        NSLayoutConstraint.activate([
            constraint,
            mainImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 20),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -80)
        ])
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            statusLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            statusLabel.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            infoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            idTextField.topAnchor.constraint(greaterThanOrEqualTo: infoLabel.bottomAnchor, constant: 40),
            idTextField.leadingAnchor.constraint(equalTo: idIconImageView.trailingAnchor, constant: 16),
            idTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            idTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -20),
            idTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            idIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            idIconImageView.centerYAnchor.constraint(equalTo: idTextField.centerYAnchor),
            idIconImageView.widthAnchor.constraint(equalToConstant: 20),
            idIconImageView.heightAnchor.constraint(equalTo: idIconImageView.widthAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            idTextFieldLineView.topAnchor.constraint(equalTo: idTextField.bottomAnchor),
            idTextFieldLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            idTextFieldLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            idTextFieldLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.bottomAnchor.constraint(equalTo: termInfoLabel.topAnchor, constant: -20),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordIconImageView.trailingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            passwordIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            passwordIconImageView.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            passwordIconImageView.widthAnchor.constraint(equalToConstant: 20),
            passwordIconImageView.heightAnchor.constraint(equalTo: passwordIconImageView.widthAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextFieldLineView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            passwordTextFieldLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordTextFieldLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordTextFieldLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            termInfoLabel.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20),
            termInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
        ])
        termInfoLabelHeightConstraint = termInfoLabel.heightAnchor.constraint(equalToConstant: 32)
        termInfoLabelHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            termCheckButton.leadingAnchor.constraint(equalTo: termInfoLabel.trailingAnchor, constant: 8),
            termCheckButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            termCheckButton.centerYAnchor.constraint(equalTo: termInfoLabel.centerYAnchor),
            termCheckButton.widthAnchor.constraint(equalToConstant: 32),
        ])
        termInfoCheckButtonHeightConstraint = termCheckButton.heightAnchor.constraint(equalToConstant: 32)
        termInfoCheckButtonHeightConstraint?.isActive = true
        
        
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(equalTo: findIdPasswordButton.topAnchor, constant: -20),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 56)
        ])

        NSLayoutConstraint.activate([
            findIdPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor),
            findIdPasswordButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            findIdPasswordButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        NSLayoutConstraint.activate([
            autoLoginTermButton.topAnchor.constraint(equalTo: findIdPasswordButton.bottomAnchor),
            autoLoginTermButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            autoLoginTermButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            autoLoginTermButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        autoLoginTermButtonBottomConstraint = autoLoginTermButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        autoLoginTermButtonBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            loadingIndicatorView.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor)
        ])
        
    }
}

