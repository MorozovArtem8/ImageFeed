import Foundation
// Тут пока только токен так как другие сущности ПОКА не используем
struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
}
