import UIKit
import Kingfisher
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() {}
    
    func logout() {
        UIBlockingProgressHUD.show()
        cleanCookies()
        cleanProfile()
        cleanToken()
        cleanProfileImage()
        kingFisherClearCache()
        urlCleanCache()
        switchSplashController()
        UIBlockingProgressHUD.dismiss()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanProfile() {
        ProfileService.shared.deleteProfile()
    }
    
    private func cleanToken() {
        let oAuth2TokenStorageImplementation = OAuth2TokenStorageImplementation()
        oAuth2TokenStorageImplementation.deleteToken()
    }
    
    private func cleanProfileImage() {
        ProfileImageService.shared.deleteProfileImage()
    }
    
    private func urlCleanCache() {
        let cache = URLCache.shared
        cache.removeAllCachedResponses()
}
    
    private func kingFisherClearCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
        
    }
    
    private func switchSplashController() {
        if let window = UIApplication.shared.windows.first {
            let splashViewController = SplashViewController()
            window.rootViewController = splashViewController
            window.makeKeyAndVisible()
            
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}
