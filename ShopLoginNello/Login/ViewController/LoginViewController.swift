//
//  LoginViewController.swift
//  ShopLoginNello
//
//  Created by nello on 2022/11/16.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - UI
    fileprivate let loginView = LoginView()
    
    // MARK: - View Life Cycle
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        addKeyboardNotification()
        addTargets()
        addDelegates()
    }
    
    // MARK: - Configure
    private func configure() {
        // 스크롤에 탭 제스쳐 추가
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onSingleTapLoginView))
        loginView.scrollView.addGestureRecognizer(singleTapRecognizer)
        // 드래그 할때 키보드 닫히도록 설정
        loginView.scrollView.keyboardDismissMode = .onDrag
    }
    
    /// 네비게이션 바
    private func configureNavigationBar() {
        // 타이틀
        self.navigationItem.titleView = {
            let label = UILabel()
            label.text = "로그인(꽃피는시절)"
            label.textColor = .black
            label.font = .systemFont(ofSize: 16, weight: .bold)
            return label
        }()
        
        // 좌측 백버튼 추가
        let backBarbuttonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(onBackBarbuttonItem))
        backBarbuttonItem.tintColor = .black
        self.navigationItem.leftBarButtonItem = backBarbuttonItem
        
        
        // 스크롤할 때 배경 white로 고정
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        
        // 구분선 추가
        self.navigationController?.navigationBar.isTranslucent = true
        let navigationLineView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .lightGray
            return view
        }()
                
        view.addSubview(navigationLineView)
        
        navigationLineView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navigationLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        navigationLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func addTargets() {
        // 로그인 버튼 탭 할 때
        loginView.loginButton.addTarget(self, action: #selector(onLogin), for: .touchDown)
        // 약관 동의 버튼 탭 할 때
        loginView.termCheckButton.addTarget(self, action: #selector(onTermCheck), for: .touchDown)
    }
    
    private func addDelegates() {
        loginView.idTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    
    // MARK: - Actions
    /// 화면 뒤로가기
    @objc private func onBackBarbuttonItem(_ sender: UIBarButtonItem) {
        showConfirmAlert(title: "알림", message: "뒤로 이동")
    }
    
    /// 로그인 시도
    @objc private func onLogin() {
        if !loginView.termCheckButton.isSelected {
            showConfirmAlert(title: "알림", message: "약관 동의가 필요합니다.")
            return
        }
        loginView.loadingIndicatorView.startAnimating()
        loginView.statusLabel.text = "로그인 중입니다.."
        loginView.infoLabel.isHidden = true
        loginView.loginButton.setTitle("", for: .normal)
        loginView.setEnableViews(isEnabled: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { [weak self] in
            self?.loginSuccess()
        })
    }
    
    /// 로그인 성공
    func loginSuccess() {
        loginView.loadingIndicatorView.stopAnimating()
        loginView.statusLabel.text = "로그인 성공!"
        loginView.loginButton.setTitle("로그인", for: .normal)
        loginView.setEnableViews(isEnabled: true)
        loginView.hiddenTermViews()
        loginView.showAutoLoginView()
    }
    
    /// 약관 동의 버튼 탭 할 때
    @objc func onTermCheck() {
        loginView.termCheckButton.isSelected.toggle()
    }
    
    /// 화면 탭 할 때
    @objc private func onSingleTapLoginView() {
        view.endEditing(true)
    }
}

// MARK: Extensions
// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    /// 키보드 return버튼 탭할 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let isEmptyInputTexts = loginView.idTextField.text!.isEmpty || loginView.passwordTextField.text!.isEmpty
        loginView.loginButton.isEnabled = !isEmptyInputTexts
        loginView.loginButton.backgroundColor = isEmptyInputTexts ? Colors.disable_color : Colors.primary_color
    }
}

// MARK: - Keyboard Show & Hide
extension LoginViewController {
    /// 키보드 Notification 추가
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    /// 키보드가 보일 때
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keybaordRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keybaordRectangle.height
            loginView.autoLoginTermButtonBottomConstraint?.constant = -keyboardHeight
        }
    }
    
    /// 키보드가 사라질 때
    @objc private func keyboardWillHide(_ notification: Notification) {
        loginView.autoLoginTermButtonBottomConstraint?.constant = -20
    }
}


// MARK: - UIAlertController
extension LoginViewController {
    func showConfirmAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let defaultAction =  UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(defaultAction)
        present(alert, animated: false)
    }
}
