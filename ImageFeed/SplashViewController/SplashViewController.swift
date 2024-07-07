import UIKit

final class SplashViewController: UIViewController {
    private weak var logoImageView: UIImageView?
    private var storage: OAuth2TokenStorage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        storage = OAuth2TokenStorageImplementation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = storage?.getToken() {
            fetchProfile(token)
        } else {
            let authVC = AuthViewController()
            authVC.delegateAuth = self
            authVC.modalPresentationStyle = .fullScreen
            present(authVC, animated: true)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
    
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось загрузить данные", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Попробовать снова", style: .default) { _ in
            if let token = self.storage?.getToken() {
                self.fetchProfile(token)
            }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

//MARK: AuthViewControllerDelegate func
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        ProfileService.shared.fetchProfile(token, completion: { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else {return}
            switch result {
            case .success(let profile):
                self.switchToTabBarController()
                ProfileImageService.shared.fetchProfileImageURL(token: token, userName: profile.userName) {_ in}
            case .failure(let error):
                showErrorAlert()
                print(error.localizedDescription)
                break
            }
        })
    }
}

//MARK: Configure UI
private extension SplashViewController {
    func configureUI() {
        view.backgroundColor = .ypBlack
        let logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "SplashScreenLogoVector") ?? UIImage()
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        self.logoImageView = logoImageView
    }
}
