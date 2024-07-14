
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

}
