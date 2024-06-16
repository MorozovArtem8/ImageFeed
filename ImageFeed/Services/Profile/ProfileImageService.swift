import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private (set) var avatarURL: String?
    private var lastUsername: String?
    private var task: URLSessionTask?
    
    private func makeProfileImageRequest(authToken: String, userName: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(userName)") else {return nil}
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfileImageURL(token: String, userName: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastUsername != userName else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastUsername = userName
        
        guard let request = makeProfileImageRequest(authToken: token, userName: userName) else {completion(.failure(AuthServiceError.invalidRequest))
            return}
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let decodedData):
                self?.avatarURL = decodedData.profileImage.small
                completion(.success(decodedData.profileImage.small))
                
                NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL": decodedData])
            case .failure(let error):
                print("ProfileImageService \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self?.task = nil
            self?.lastUsername = nil
        }
        self.task = task
        task.resume()
    }
}
