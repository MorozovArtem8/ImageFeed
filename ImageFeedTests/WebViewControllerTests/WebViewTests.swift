
@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let webViewController = WebViewViewController()
        let webViewPresenter = WebViewPresenterSpy()
        webViewController.presenter = webViewPresenter
        webViewPresenter.view = webViewController
        //when
        _ = webViewController.view
        
        //then
        XCTAssertTrue(webViewPresenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        //given
        let webViewController = WebViewViewControllerSpy()
        let webViewPresenter = WebViewPresenterSpy()
        webViewController.presenter = webViewPresenter
        webViewPresenter.view = webViewController
        
        //when
        XCTAssertFalse(webViewController.loadRequestCalled)
        webViewPresenter.viewDidLoad()
        
        //then
        XCTAssertTrue(webViewPresenter.viewDidLoadCalled)
    }
    
    func testProgressVisibleWhenLessTheOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.5
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper()
        
        //when
        let url = authHelper.authURL()
        let urlString = url!.absoluteString
        
        //then
        XCTAssertTrue(urlString.contains(configuration.unsplashAuthorizeURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        //given
        let authHelper = AuthHelper()
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        urlComponents?.queryItems = [
            URLQueryItem(name: "code", value: "test code"),
        ]
        guard let url = urlComponents?.url else {return}
        
        //when
        let testCode = authHelper.code(from: url)
        
        //then
        XCTAssertEqual(testCode, "test code")
    }

}
