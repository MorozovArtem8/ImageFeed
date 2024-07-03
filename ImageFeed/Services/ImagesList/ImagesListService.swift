import UIKit

protocol ImagesListServiceProtocol {
    var lastLoadedPage: Int? { get set }
    func fetchPhotosNextPage()
    var photos: [Photo] {get}
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImagesListService: ImagesListServiceProtocol {
    init() {
        storage = OAuth2TokenStorageImplementation()
    }
    private var storage: OAuth2TokenStorage?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var task: URLSessionTask?
    
    private (set) var photos: [Photo] = []
    
    var lastLoadedPage: Int?
    
    private func makePhotosRequest(authToken: String, nextPage: Int) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.unsplashPhotosURLString) else {return nil}
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(nextPage)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        
        guard let url = urlComponents.url else {return nil}
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchPhotosNextPage(){
        guard task == nil else {
            return}
        assert(Thread.isMainThread)
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let token = storage?.getToken() else { return}
        guard let request = makePhotosRequest(authToken: token, nextPage: nextPage) else {
            return}
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let httpResponse = response as? HTTPURLResponse
                print(NetworkError.httpStatusCode(httpResponse?.statusCode ?? 0))
                return
            }
            
            guard let data = data else {return}
            
            do {
                let photosJsonArray = try JSONDecoder().decode([PhotoResult].self, from: data)
                
                for photo in photosJsonArray {
                    let id = photo.id
                    let size = CGSize(width: Double(photo.width), height: Double(photo.height))
                    let dateFormatter = ISO8601DateFormatter()
                    let createdAt: Date? = dateFormatter.date(from: photo.createdAt) ?? nil
                    let welcomeDescription = photo.description
                    let thumbImageURL = photo.urls.thumb
                    let largeImageURL = photo.urls.full
                    let isLiked = photo.isLiked
                    
                    let photo = Photo(id: id, size: size, createdAt: createdAt, welcomeDescription: welcomeDescription, thumbImageURL: thumbImageURL, largeImageURL: largeImageURL, isLiked: isLiked)
                    DispatchQueue.main.async { [weak self] in
                        self?.photos.append(photo)
                    }
                }
                
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
            }
            catch {
                print("Ошибка декодирования: \(error.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
            }
            
            self.task = nil
            self.lastLoadedPage = nextPage
        }
        
        
        self.task = task
        task.resume()
    }
}
//MARK: Like/Unlike photo service
extension ImagesListService {
    private func makeChangeLikeRequest(authToken: String, photoId: String, isLike: Bool) -> URLRequest? {
        
        guard let urlsString = (Constants.defaultBaseURL?.absoluteString),
              let url = URL(string: "\(urlsString)photos/\(photoId)/like") else {return nil}
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = isLike ? "DELETE" : "POST" 
        return request
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard task == nil,
        let token = storage?.getToken() else { return }
        assert(Thread.isMainThread)
        
        guard let request = makeChangeLikeRequest(authToken: token, photoId: photoId, isLike: isLike) else { return }
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                if let index = self.photos.firstIndex(where: {$0.id == photoId}) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(id: photo.id, size: photo.size, createdAt: photo.createdAt, welcomeDescription: photo.welcomeDescription, thumbImageURL: photo.thumbImageURL, largeImageURL: photo.largeImageURL, isLiked: !photo.isLiked)
                    self.photos[index] = newPhoto
                }
                completion(.success(()))
            case .failure(let error):
                print("🚩 ImagesListService changeLike \(error.localizedDescription) 🚩")
                completion(.failure(error))
            }
            
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
