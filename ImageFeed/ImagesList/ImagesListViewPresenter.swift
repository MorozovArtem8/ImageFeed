import UIKit

public protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    
    func viewDidLoad()
    func updatePhotos()
    func fetchNextPage()
    func imageListCellDidTapLike(at indexPath: IndexPath)
    func formattedDate(from date: Date) -> String
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    
    private var dateFormatter: DateFormatter
    
    var photos: [Photo] = []
    
    var view: ImagesListViewControllerProtocol?
    
    private var imagesListService: ImagesListServiceProtocol
    private var imagesListServiceObserver: NSObjectProtocol?
    
    init(imagesListService: ImagesListServiceProtocol = ImagesListService(), dateFormatter: DateFormatter = DateFormatter()) {
        self.imagesListService = imagesListService
        
        self.dateFormatter = dateFormatter
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.timeStyle = .none
        self.dateFormatter.locale = .current
        
    }
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let self = self else {return}
            updatePhotos()
        })
    }
    
    func updatePhotos() {
        
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        let updatePhotos = imagesListService.photos
        photos = updatePhotos
        
        if oldCount != newCount {
            let indexPath = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            view?.updateTableViewAnimated(indexPath: indexPath)
        }
        
    }
    
    func fetchNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func imageListCellDidTapLike(at indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked, { [weak self] result in
            switch result {
            case .success(_):
                guard let updatePhotos = self?.imagesListService.photos else {return}
                self?.photos = updatePhotos
                if let currentPhotoIsLiked = self?.photos[indexPath.row].isLiked {
                    self?.view?.updateCell(at: indexPath, isLiked: !currentPhotoIsLiked)
                }
            case .failure(let error):
                print("🚩 ImageListCellDidTapLike Ошибка запроса \(error.localizedDescription)")
                //TODO: Показать ошибку с использованием UIAlertController
            }
            UIBlockingProgressHUD.dismiss()
        })
    }
    
    func formattedDate(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
