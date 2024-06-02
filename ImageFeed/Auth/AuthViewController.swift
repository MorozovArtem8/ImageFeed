import UIKit

final class AuthViewController: UIViewController {
  
    private let showWebViewSegueID = "ShowWebView"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}