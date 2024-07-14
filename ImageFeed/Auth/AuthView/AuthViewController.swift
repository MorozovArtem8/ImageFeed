import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    
    private weak var logoImageView: UIImageView?
    private weak var loginButton: UIButton?
    
    private var tokenStorage: OAuth2TokenStorage?
    weak var delegateAuth: AuthViewControllerDelegate?
    
    private let showWebViewSegueID = "ShowWebView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tokenStorage = OAuth2TokenStorageImplementation()
    }
    
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
}

//MARK: WebViewViewControllerDelegate func
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let result):
                self.tokenStorage?.setToken(token: result) // Сохраняем токен
                
                self.delegateAuth?.didAuthenticate(self) // вызываем меетод что токен получен
                
            case .failure(let error):
                showErrorAlert()
                if let error = error as? NetworkError {
                    switch error {
                    case .httpStatusCode(_):
                        print(error)
                    case.urlRequestError(_):
                        print("Ошибка запроса")
                    case.urlSessionError:
                        print("Ошбка Сессии")
                    }
                } else {
                    print("Ошибка декодера")
                }
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

//MARK: Configure UI
private extension AuthViewController {
    func configureUI() {
        view.backgroundColor = .ypBlack
        configureLogo()
        configureLoginButton()
    }
    
    func configureLogo() {
        let logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "auth_screen_logo") ?? UIImage()
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        self.logoImageView = logoImageView
    }
    
    func configureLoginButton() {
        
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Войти", for: .normal)
        loginButton.backgroundColor = .white
        loginButton.tintColor = .ypBlack
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        loginButton.layer.cornerRadius = 16
        loginButton.clipsToBounds = true
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            loginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        loginButton.addTarget(self, action: #selector(self.loginButtonTapp), for: .touchUpInside)
        self.loginButton = loginButton
    }
    
    @objc func loginButtonTapp() {
        let webViewPresenter = WebViewPresenter(authHelper: AuthHelper())
        let webViewViewController = WebViewViewController()
        
        webViewViewController.presenter = webViewPresenter
        webViewPresenter.view = webViewViewController
        webViewViewController.delegate = self
       
        webViewViewController.modalPresentationStyle = .fullScreen
        present(webViewViewController, animated: true)
    }
}
