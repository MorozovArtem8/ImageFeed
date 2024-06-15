import Foundation

struct ProfileResult: Codable {
    let id: String
    let userName: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}