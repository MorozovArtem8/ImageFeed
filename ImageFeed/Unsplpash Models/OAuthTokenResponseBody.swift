import Foundation
// Тут пока только токен так как другие сущности ПОКА не используем
struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
       case accessToken = "access_token"
    }
}
