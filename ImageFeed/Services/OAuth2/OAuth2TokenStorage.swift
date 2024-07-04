import Foundation
import SwiftKeychainWrapper

protocol OAuth2TokenStorage {
    func getToken() -> String?
    func setToken(token: String)
}

final class OAuth2TokenStorageImplementation: OAuth2TokenStorage{
    
    private var token: String? {
        get {
            let token: String? = KeychainWrapper.standard.string(forKey: "Auth token")
            return token
        }
        
        set {
            guard let token = newValue else { return }
            let isSuccess = KeychainWrapper.standard.set(token, forKey: "Auth token")
            guard isSuccess else {
                print("KeychainWrapper set token failed")
                return
            }
        }
    }
    
    func getToken() -> String? {
        return token
    }
    
    func setToken(token: String) {
        self.token = token
    }
    
    func deleteToken() {
        let isSuccess = KeychainWrapper.standard.removeObject(forKey: "Auth token")
        if !isSuccess {
            print("Failed to delete token from Keychain")
        }
    }
}
