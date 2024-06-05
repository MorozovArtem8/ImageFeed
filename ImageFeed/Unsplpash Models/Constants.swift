import Foundation

enum Constants {
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")
    
    static let accessKey = "ClsYis--ACFNRr0m1EaprjUh_JGdP94WEgjKJ2EEpwk"
    static let secretKey = "d6Sur_YM3IjkU3PLe4oCRaXUN5PCPraNToSBMBowJL8"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
    static let accessScope = "public+read_user+write_likes"
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashOathTokenString = "https://unsplash.com/oauth/token"
}
