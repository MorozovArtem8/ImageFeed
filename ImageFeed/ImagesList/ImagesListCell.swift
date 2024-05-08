import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellDateLabel: UILabel!
    @IBOutlet weak var cellLikeButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    
    static let reuseIdentifier = "ImagesListCell"
    
    
}