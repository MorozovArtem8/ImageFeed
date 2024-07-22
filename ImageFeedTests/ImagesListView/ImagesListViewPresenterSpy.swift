import UIKit
import ImageFeed

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    
    var view: ImagesListViewControllerProtocol?
    
    var photos: [Photo] = []
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updatePhotos() {
        
    }
    
    func fetchNextPage() {
        
    }
    
    func imageListCellDidTapLike(at indexPath: IndexPath) {
        
    }
    
    func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = .current
        
        return dateFormatter.string(from: date)
    }
    
}
