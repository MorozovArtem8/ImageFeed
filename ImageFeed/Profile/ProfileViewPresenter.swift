import UIKit
import Kingfisher

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func downloadAvatar()
    func showLogoutAlert()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    private var profileImageServiceObserver: NSObjectProtocol?
    weak var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        
        view?.updateProfileDetails(profile: ProfileService.shared.profile ?? Profile(userName: " ", firstName: " ", lastName: " ", bio: " "))
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else {return}
            
            self.downloadAvatar()
        }
        
        downloadAvatar()
    }
    
    func downloadAvatar() {
        guard let profileImageUrl = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageUrl)
        else {return}
        
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                self.view?.updateAvatar(with: value.image)
            case.failure(let error):
                print("🚩 KingfisherManager \(error)")
            }
        }
    }
    
    func showLogoutAlert() {
        view?.showLogoutAlert()
    }
    
    
}
