import UIKit

protocol ImagesListViewControllerProtocol {
    var presenter: ImageListViewPresenterProtocol {get set}
    
    func updateTableViewAnimated(indexPath: [IndexPath])
    func updateCell(at indexPath: IndexPath, isLiked: Bool)
}

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    var presenter: ImageListViewPresenterProtocol
    private weak var tableView: UITableView?
    
    init(presenter: ImageListViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        presenter.viewDidLoad()
        
    }
    
    func updateTableViewAnimated(indexPath: [IndexPath]) {
        self.tableView?.performBatchUpdates {
                tableView?.insertRows(at: indexPath, with: .automatic)
            } completion: { _ in}
    }
    
    func updateCell(at indexPath: IndexPath, isLiked: Bool) {
        guard let cell = tableView?.cellForRow(at: indexPath) as? ImagesListCell else {return}
        cell.setIsLiked(isLikedUpdate: isLiked)
    }
}

//MARK: ImagesListCellDelegate func
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else {return}
        presenter.imageListCellDidTapLike(at: indexPath)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        let urlForDownloadImage = presenter.photos[indexPath.row].thumbImageURL
        let isLiked = presenter.photos[indexPath.row].isLiked
        
        if let dateNotNil = presenter.photos[indexPath.row].createdAt {
            let newDateString = presenter.formattedDate(from: dateNotNil)
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
        singleImageVC.largeURL = presenter.photos[indexPath.row].largeImageURL
        singleImageVC.modalPresentationStyle = .fullScreen
        present(singleImageVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.calculateHeightForRow(tableView, at: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter.photos.count {
            presenter.fetchNextPage()
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
