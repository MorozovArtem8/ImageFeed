import Foundation
import ImageFeed

final class ImagesListServiceMock: ImagesListServiceProtocol {
    var fetchPhotosNextPageCalled: Bool = false
    
    var lastLoadedPage: Int?
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    var photos: [Photo] = []
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, any Error>) -> Void) {
        
    }
    
    
}
