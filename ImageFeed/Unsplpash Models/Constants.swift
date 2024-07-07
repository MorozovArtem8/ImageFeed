import Foundation

enum Constants {
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")
    
    static let accessKey = "7SvuA5Jsr6dT8FyRmLBs8B6XThDFcQ3PSLeL-wIaoJY"
    static let secretKey = "Hxadsezx_5tCMA0ZnMvSCwhfiMgcY85TpJxq-LHdWGU"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
    static let accessScope = "public+read_user+write_likes"
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashOathTokenString = "https://unsplash.com/oauth/token"
    
    static let unsplashProfileURLString = "https://api.unsplash.com/users/"
    static let unsplashMeURLString = "https://api.unsplash.com/me"
    
    static let unsplashPhotosURLString = "https://api.unsplash.com/photos"
}
