import UIKit

final class ProfileService {
    
    private(set) var profile: Profile?
    static let shared = ProfileService()
    private init(){}
    
    private var lastToken: String?
    private var task: URLSessionTask?
    
    private func makeProfileRequest(authToken: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {return nil}
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastToken != token else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastToken = token
        
        guard let request = makeProfileRequest(authToken: token) else {completion(.failure(AuthServiceError.invalidRequest))
            return}
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    
                    let profileResult = try decoder.decode(ProfileResult.self, from: data)
                    let profile = Profile(userName: profileResult.userName, firstName: profileResult.firstName, lastName: profileResult.lastName, bio: profileResult.bio)
                    self?.profile = profile
                    completion(.success(profile))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
            self?.task = nil
            self?.lastToken = nil
        }
        self.task = task
        task.resume()
    }
}
