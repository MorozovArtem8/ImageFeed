@testable import ImageFeed
import XCTest

final class ProfileViewTessts: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let profileViewController = ProfileViewController()
        let profileViewPresenter = ProfileViewPresenterSpy()
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController
        
        //when
        _ = profileViewController.view
        
        //then
        XCTAssertTrue(profileViewPresenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateProfileDetails() {
        //given
        let profileViewController = ProfileViewControllerSpy()
        let profileViewPresenter = ProfileViewPresenter()
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController
        
        //when
        XCTAssertFalse(profileViewController.updateProfileDetailsCalls)
        profileViewPresenter.viewDidLoad()
        
        //then
        XCTAssertTrue(profileViewController.updateProfileDetailsCalls)
        
    }
    
    func testPresenterCallsShowLogoutAlert() {
        //given
        let profileViewController = ProfileViewControllerSpy()
        let profileViewPresenter = ProfileViewPresenter()
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController
        
        //when
        XCTAssertFalse(profileViewController.showLogoutAlertCalls)
        profileViewPresenter.showLogoutAlert()
        
        //then
        XCTAssertTrue(profileViewController.showLogoutAlertCalls)
    }
}
