import Foundation

enum Constants {
    
    static let accessKey = "7SvuA5Jsr6dT8FyRmLBs8B6XThDFcQ3PSLeL-wIaoJY"
    static let secretKey = "Hxadsezx_5tCMA0ZnMvSCwhfiMgcY85TpJxq-LHdWGU"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashOathTokenString = "https://unsplash.com/oauth/token"
    
    static let unsplashProfileURLString = "https://api.unsplash.com/users/"
    static let unsplashMeURLString = "https://api.unsplash.com/me"
    
    static let unsplashPhotosURLString = "https://api.unsplash.com/photos"
}

struct AuthConfiguration {
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey, secretKey: Constants.secretKey, redirectURI: Constants.redirectURI, accessScope: Constants.accessScope, defaultBaseURL: Constants.defaultBaseURL!, unsplashPhotosURLString: Constants.unsplashPhotosURLString, unsplashMeURLString: Constants.unsplashMeURLString, unsplashProfileURLString: Constants.unsplashProfileURLString, unsplashOathTokenString: Constants.unsplashOathTokenString, unsplashAuthorizeURLString: Constants.unsplashAuthorizeURLString)
    }
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    
    let defaultBaseURL: URL
    let unsplashPhotosURLString: String
    let unsplashMeURLString: String
    let unsplashProfileURLString: String
    let unsplashOathTokenString: String
    let unsplashAuthorizeURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, unsplashPhotosURLString: String, unsplashMeURLString: String, unsplashProfileURLString: String, unsplashOathTokenString: String, unsplashAuthorizeURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.unsplashPhotosURLString = unsplashPhotosURLString
        self.unsplashMeURLString = unsplashMeURLString
        self.unsplashProfileURLString = unsplashProfileURLString
        self.unsplashOathTokenString = unsplashOathTokenString
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
    }
}
