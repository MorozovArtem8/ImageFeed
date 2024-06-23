import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    private init(){}
    
    private(set) var profile: Profile?
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
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let decodedData):
                let profile = Profile(userName: decodedData.userName, firstName: decodedData.firstName, lastName: decodedData.lastName, bio: decodedData.bio)
                self?.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print("🚩 ProfileService \(error.localizedDescription) 🚩")
                completion(.failure(error))
            }
            
            self?.task = nil
            self?.lastToken = nil
        }
        self.task = task
        task.resume()
    }
}
