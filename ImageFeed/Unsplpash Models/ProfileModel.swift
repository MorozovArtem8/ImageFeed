import Foundation

public struct Profile {
    let userName: String
    let firstName:String
    let lastName: String
    var name: String {
        return "\(firstName) \(lastName)"
    }
    var loginName: String {
        return "@\(userName)"
    }
    let bio: String?
}
