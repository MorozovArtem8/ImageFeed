import UIKit
import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    
    var updateProfileDetailsCalls: Bool = false
    var showLogoutAlertCalls: Bool = false
    
    func updateProfileDetails(profile: Profile) {
        updateProfileDetailsCalls = true
    }
    
    func updateAvatar(with image: UIImage?) {
        
    }
    
    func showLogoutAlert() {
        showLogoutAlertCalls = true
    }
    
    
}
