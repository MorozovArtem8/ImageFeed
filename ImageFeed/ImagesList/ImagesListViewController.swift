import UIKit

final class ImagesListViewController: UIViewController {
    private weak var tableView: UITableView?
    private var imagesListService: ImagesListServiceProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    
    private var photos: [Photo] = []
    //private let photosName: [String] = Array(0..<21).map{ "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
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

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        let urlForDownloadImage = URL(string: photos[indexPath.row].thumbImageURL) ?? URL(fileURLWithPath: "")
        let cellDate = dateFormatter.string(from: Date())
        let isLiked = indexPath.row % 2 == 0
        
        imageListCell.configureCell(urlForDownloadImage: urlForDownloadImage, date: cellDate, isLiked: isLiked)
        
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageVC = SingleImageViewController()
        singleImageVC.largeURL = URL(string: photos[indexPath.row].largeImageURL)
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
