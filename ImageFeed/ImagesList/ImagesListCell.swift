import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLikeButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var cellDateLabel: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"
    
    func configureCell(image: UIImage, date: String, isLiked: Bool) {
        cellDateLabel.backgroundColor = UIColor.clear
        cellImageView.image = image
        cellDateLabel.text = date
        
        let likerImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cellLikeButton.setImage(likerImage, for: .normal)
    }
    
    
}
