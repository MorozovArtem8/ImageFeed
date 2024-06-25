import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    
    private weak var webView: WKWebView?
    private weak var progressView: UIProgressView?
    private weak var backButton: UIButton?
    
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    //MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        estimatedProgressObservation = webView?.observe(\.estimatedProgress) { [weak self] _, _  in
            guard let self = self else {return}
            self.updateProgress()
        }
        webView?.navigationDelegate = self
        loadAuthView()
        
    }
    
    private func updateProgress() {
        guard let progressView = progressView,
              let webView = webView else {return}
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString) else {
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            return
        }
        
        let request = URLRequest(url: url)
        webView?.load(request)
    }
    
}
//MARK: WKNavigationDelegate func
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let urlComponent = URLComponents(string: url.absoluteString),
           urlComponent.path == "/oauth/authorize/native",
           let items = urlComponent.queryItems,
           let codeItems = items.first(where: {$0.name == "code"}) {
            return codeItems.value
        } else {
            return nil
        }
    }
}

//MARK: Configure UI

private extension WebViewViewController {
    func configureUI() {
        view.backgroundColor = .white
        configureBackButton()
        configureProgressView()
        configureWebView()
    }
    
    func configureBackButton() {
        let exitButtonImage = UIImage(named: "nav_back_button")
        let exitButtonImageDefaultSF = UIImage(systemName: "chevron.backward") ?? UIImage()
        
        let button = UIButton()
        button.addTarget(self, action: #selector(self.didTapBackButton), for: .touchUpInside)
        button.setImage(exitButtonImage ?? exitButtonImageDefaultSF, for: .normal)
        button.tintColor = .ypBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        self.backButton = button
    }
    
    @objc func didTapBackButton() {
        delegate?.webViewViewControllerDidCancel(self)
        
    }
    
    func configureProgressView() {
        guard let backButton = backButton else {return}
        
        let progressView = UIProgressView()
        progressView.progress = 0
        progressView.progressTintColor = .ypBlack
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 0)
        ])
        
        self.progressView = progressView
    }
    
    func configureWebView() {
        guard let progressView = progressView else {return}
        
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 0),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        self.webView = webView
    }
    
}
