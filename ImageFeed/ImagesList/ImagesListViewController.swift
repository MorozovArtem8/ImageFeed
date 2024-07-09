import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListViewController: UIViewController {
    
    deinit {
        print("deinit ImagesListViewController")
    }
    
    private weak var tableView: UITableView?
    private var imagesListService: ImagesListServiceProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    
    private var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = .current
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesListService = ImagesListService()
        imagesListService?.fetchPhotosNextPage()
        configureUI()
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let self = self else {return}
            updateTableViewAnimated()
        })
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        guard let newCount = imagesListService?.photos.count else {return}
        guard let updatePhotos = imagesListService?.photos else {return}
        photos = updatePhotos
        
        if oldCount != newCount {
            self.tableView?.performBatchUpdates {
                let indexPath = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView?.insertRows(at: indexPath, with: .automatic)
            } completion: { _ in}
        }
    }
}

//MARK: ImagesListCellDelegate func
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else {return}
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService?.changeLike(photoId: photo.id, isLike: photo.isLiked, { [weak self] result in
            switch result {
            case .success(_):
                guard let updatePhotos = self?.imagesListService?.photos else {return}
                self?.photos = updatePhotos
                if let currentPhotoIsLiked = self?.photos[indexPath.row].isLiked {
                    cell.setIsLiked(isLikedUpdate: !currentPhotoIsLiked)
                }
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("🚩 ImageListCellDidTapLike Ошибка запроса \(error.localizedDescription)")
                //TODO: Показать ошибку с использованием UIAlertController
            }
            
        })
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        let urlForDownloadImage = photos[indexPath.row].thumbImageURL
        let isLiked = photos[indexPath.row].isLiked
        
        if let dateNotNil = photos[indexPath.row].createdAt {
            let newDateString = dateFormatter.string(from: dateNotNil)
            imageListCell.configureCell(urlForDownloadImage: urlForDownloadImage, date: newDateString, isLiked: isLiked)
            return imageListCell
        }
        imageListCell.configureCell(urlForDownloadImage: urlForDownloadImage, date: "", isLiked: isLiked)
        return imageListCell
        
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageVC = SingleImageViewController()
        singleImageVC.largeURL = photos[indexPath.row].largeImageURL
        singleImageVC.modalPresentationStyle = .fullScreen
        present(singleImageVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageViewConstraints = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageViewConstraints.left - imageViewConstraints.right
        let widthRatio = imageViewWidth / photos[indexPath.row].size.width
        let imageViewHeight = widthRatio * photos[indexPath.row].size.height + 8
        
        return imageViewHeight
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService?.fetchPhotosNextPage()
        }
    }
}
//MARK: Configure UI
private extension ImagesListViewController {
    func configureUI() {
        configureTableView()
    }
    
    func configureTableView() {
        let tableView = UITableView()
        
        tableView.backgroundColor = .ypBlack
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.alwaysBounceVertical = true
        tableView.contentMode = .scaleToFill
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        self.tableView = tableView
        
    }
}
