import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? {get set}
    
    func updateProfileDetails(profile: Profile)
    func updateAvatar(with image: UIImage?)
    func showLogoutAlert()
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    var presenter: ProfileViewPresenterProtocol?
    
    private weak var profilePhotoImageView: UIImageView?
    private weak var userNameLabel: UILabel?
    private weak var userEmailLabel: UILabel?
    private weak var userDescriptionLabel: UILabel?
    private weak var exitButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        presenter?.viewDidLoad()
    }
    
    func updateAvatar(with image: UIImage?) {
        self.profilePhotoImageView?.image = image
    }
    
    func updateProfileDetails(profile: Profile) {
        userNameLabel?.text = profile.name
        userEmailLabel?.text = profile.loginName
        userDescriptionLabel?.text = profile.bio
    }
    
    func showLogoutAlert() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Alert"
        let NoAction = UIAlertAction(title: "Нет", style: .cancel)
        let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
            ProfileLogoutService.shared.logout()
        }
        alert.addAction(yesAction)
        alert.addAction(NoAction)
        self.present(alert, animated: true)
    }
    
}
//MARK: Configure UI
extension ProfileViewController {
    private func configureUI() {
        view.backgroundColor = .ypBlack
        configureProfilePhotoImageView()
        configureExitButton()
        configureUserNameLabel()
        configureUserEmailLabel()
        configureUserDescriptionLabel()
    }
    
    private func configureProfilePhotoImageView() {
        let profilePhotoImageView = UIImageView()
        profilePhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        profilePhotoImageView.tintColor = .gray
        profilePhotoImageView.layer.cornerRadius = 35
        profilePhotoImageView.clipsToBounds = true
        view.addSubview(profilePhotoImageView)
        profilePhotoImageView.image = UIImage(systemName: "person.crop.circle.fill")
        NSLayoutConstraint.activate([
            profilePhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profilePhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profilePhotoImageView.widthAnchor.constraint(equalToConstant: 70),
            profilePhotoImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        self.profilePhotoImageView = profilePhotoImageView
    }
    
    private func configureExitButton() {
        guard let profilePhotoImageView = profilePhotoImageView else {return}
        let exitButtonImage = UIImage(named: "logout_button")
        let exitButtonImageDefaultSF = UIImage(systemName: "ipad.and.arrow.forward") ?? UIImage()
        
        let button = UIButton()
        button.accessibilityIdentifier = "exitButton"
        button.addTarget(self, action: #selector(self.exitButtonTapp), for: .touchUpInside)
        button.setImage(exitButtonImage ?? exitButtonImageDefaultSF, for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            button.centerYAnchor.constraint(equalTo: profilePhotoImageView.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        self.exitButton = button
    }
    
    @objc private func exitButtonTapp() {
        presenter?.showLogoutAlert()
    }
    
    private func configureUserNameLabel() {
        guard let profilePhotoImageView = profilePhotoImageView else {return}
        let userNameLabel = UILabel()
        userNameLabel.textColor = .white
        
        userNameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        userNameLabel.text = " "
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userNameLabel.topAnchor.constraint(equalTo: profilePhotoImageView.bottomAnchor, constant: 8)
            
        ])
        
        self.userNameLabel = userNameLabel
    }
    
    private func configureUserEmailLabel() {
        guard let userNameLabel = userNameLabel else {return}
        
        let userEmailLabel = UILabel()
        userEmailLabel.textColor = #colorLiteral(red: 0.7369984984, green: 0.7409694791, blue: 0.7575188279, alpha: 1)
        
        userEmailLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        userEmailLabel.text = " "
        
        userEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userEmailLabel)
        
        NSLayoutConstraint.activate([
            userEmailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userEmailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userEmailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8)
            
        ])
        
        self.userEmailLabel = userEmailLabel
    }
    
    private func configureUserDescriptionLabel() {
        guard let userEmailLabel = userEmailLabel else {return}
        
        let userDescriptionLabel = UILabel()
        userDescriptionLabel.textColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1)
        
        userDescriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        userDescriptionLabel.text = " "
        
        userDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userDescriptionLabel)
        
        NSLayoutConstraint.activate([
            userDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userDescriptionLabel.topAnchor.constraint(equalTo: userEmailLabel.bottomAnchor, constant: 8)
            
        ])
        
        self.userDescriptionLabel = userDescriptionLabel
    }
}
