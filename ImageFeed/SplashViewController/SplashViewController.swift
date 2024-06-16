import UIKit

final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private var storage: OAuth2TokenStorage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = OAuth2TokenStorageImplementation()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = storage?.getToken() {
            fetchProfile(token)
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for ShowAuthFlow")
                return
            }
            viewController.delegateAuth = self
        }else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "TabBarViewController")
        window.rootViewController = tabBarController
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
                ProfileImageService.shared.fetchProfileImageURL(token: token, userName: profile.userName) {_ in}
                self.switchToTabBarController()
            case .failure(let error):
                print(error)
                break
            }
        })
    }
}
