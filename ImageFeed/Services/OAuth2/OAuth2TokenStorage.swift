import Foundation

protocol OAuth2TokenStorage {
    func getToken() -> String?
    func setToken(token: String)
}

final class OAuth2TokenStorageImplementation: OAuth2TokenStorage{
    
    private let userDefaults = UserDefaults.standard
    
    private var token: String? {
        get {
            return userDefaults.string(forKey: "token")
        }
        
        set {
            userDefaults.set(newValue, forKey: "token")
        }
    }
    
    func getToken() -> String? {
        return token
    }
    
    func setToken(token: String) {
        self.token = token
    }
}
