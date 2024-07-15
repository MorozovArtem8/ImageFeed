import UIKit

protocol ImageListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    
    func viewDidLoad()
    func updatePhotos()
    func fetchNextPage()
    func imageListCellDidTapLike(at indexPath: IndexPath)
    func formattedDate(from date: Date) -> String
    func calculateHeightForRow(_ tableView: UITableView, at indexPath: IndexPath) -> CGFloat
}

final class ImageListViewPresenter: ImageListViewPresenterProtocol {
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = .current
        return formatter
    }()
    
    var photos: [Photo] = []
    
    var view: ImagesListViewControllerProtocol?
    
    private var imagesListService: ImagesListServiceProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        imagesListService = ImagesListService()
        imagesListService?.fetchPhotosNextPage()
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let self = self else {return}
            updatePhotos()
        })
    }
    
    func updatePhotos() {
        
        let oldCount = photos.count
        guard let newCount = imagesListService?.photos.count else {return}
        guard let updatePhotos = imagesListService?.photos else {return}
        photos = updatePhotos
        
        if oldCount != newCount {
            let indexPath = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            view?.updateTableViewAnimated(indexPath: indexPath)
        }
        
    }
    
    func fetchNextPage() {
        imagesListService?.fetchPhotosNextPage()
    }
    
    func imageListCellDidTapLike(at indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService?.changeLike(photoId: photo.id, isLike: photo.isLiked, { [weak self] result in
            switch result {
            case .success(_):
                guard let updatePhotos = self?.imagesListService?.photos else {return}
                self?.photos = updatePhotos
                if let currentPhotoIsLiked = self?.photos[indexPath.row].isLiked {
                    self?.view?.updateCell(at: indexPath, isLiked: !currentPhotoIsLiked)
                }
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("🚩 ImageListCellDidTapLike Ошибка запроса \(error.localizedDescription)")
                //TODO: Показать ошибку с использованием UIAlertController
            }
            
        })
    }
    
    func formattedDate(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func calculateHeightForRow(_ tableView: UITableView, at indexPath: IndexPath) -> CGFloat {
        let imageViewConstraints = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageViewConstraints.left - imageViewConstraints.right
        let widthRatio = imageViewWidth / photos[indexPath.row].size.width
        let imageViewHeight = widthRatio * photos[indexPath.row].size.height + 8
        
        return imageViewHeight
    }
}
