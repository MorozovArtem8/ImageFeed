import UIKit

protocol ImagesListServiceProtocol {
    var lastLoadedPage: Int? { get set }
    func fetchPhotosNextPage(token: String, completion: @escaping (Result<String, Error>) -> Void)
}

final class ImagesListService: ImagesListServiceProtocol {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var task: URLSessionTask?
    
    private (set) var photos: [Photo] = []
    
    var lastLoadedPage: Int?
    
    private func makePhotosRequest(authToken: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.unsplashPhotosURLString) else {return nil}
        urlComponents.queryItems = [
            URLQueryItem(name: "per_page", value: "10"),
        ]
        
        guard let url = urlComponents.url else {return nil}
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchPhotosNextPage(token: String, completion: @escaping (Result<String, Error>) -> Void) {
        if let task {
            return
        }
        assert(Thread.isMainThread)
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makePhotosRequest(authToken: token) else {completion(.failure(AuthServiceError.invalidRequest))
            return}
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let photoResult):
                for photo in photoResult {
                    self.photos.append(Photo(id: photo.id, size: CGSize(), createdAt: nil, welcomeDescription: photo.description, thumbImageURL: photo.urls.thumb, largeImageURL: photo.urls.full, isLiked: photo.likedByUser))
                }
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                completion(.success("Успех"))
            case .failure(let error):
                print("🚩 ImagesListService \(error.localizedDescription) 🚩")
                completion(.failure(error))
            }
            
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
}

