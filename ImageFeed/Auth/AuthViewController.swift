import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    
    private var tokenStorage: OAuth2TokenStorage?
    weak var delegateAuth: AuthViewControllerDelegate?
    
    private let showWebViewSegueID = "ShowWebView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tokenStorage = OAuth2TokenStorageImplementation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueID {
            guard let viewController = segue.destination as? WebViewViewController else {fatalError("Failed to prepare for \(showWebViewSegueID)")}
            viewController.delegate = self
        }else {
            super.prepare(for: segue, sender: sender)
        }
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
