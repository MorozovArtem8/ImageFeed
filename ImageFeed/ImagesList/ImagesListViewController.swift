import UIKit

final class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
    }
    
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        let cellMainImage = UIImage(named: photosName[indexPath.row])
        let cellDate = dateFormatter.string(from: Date())
        let isLiked = indexPath.row % 2 == 0
        imageListCell.configureCell(image: cellMainImage ?? UIImage(), date: cellDate, isLiked: isLiked)
        
        return imageListCell
    }
    
    
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageViewConstraints = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageViewConstraints.left - imageViewConstraints.right
        let widthRatio = imageViewWidth / image.size.width
        let imageViewHeight = widthRatio * image.size.height + 8
        
        return imageViewHeight
        
    }
}
