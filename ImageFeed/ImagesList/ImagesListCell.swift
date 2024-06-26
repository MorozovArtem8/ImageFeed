import UIKit

final class ImagesListCell: UITableViewCell {
    private weak var cellImageView: UIImageView?
    private weak var cellLikeButton: UIButton?
    private weak var gradientView: UIView?
    private weak var cellDateLabel: UILabel?
    
    static let reuseIdentifier = "ImagesListCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(image: UIImage, date: String, isLiked: Bool) {
        cellDateLabel?.backgroundColor = UIColor.clear
        cellImageView?.image = image
        cellDateLabel?.text = date
        
        let likerImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cellLikeButton?.setImage(likerImage, for: .normal)
    }
}

//MARK: Configure UI
private extension ImagesListCell {
    func configureUI() {
        contentView.backgroundColor = .clear
        self.selectionStyle = .none
        backgroundColor = .clear
        configureCellImageView()
        configureCellLikeButton()
        configureGradientView()
        configureCellDateLabel()
    }
    
    func configureCellImageView() {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        self.cellImageView = imageView
    }
    
    func configureCellLikeButton() {
        guard let cellImageView = cellImageView else {return}
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "like_button_on"), for: .normal)
        
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: cellImageView.topAnchor),
            button.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor),
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        self.cellLikeButton = button
    }
    
    func configureGradientView() {
        guard let cellImageView = cellImageView else {return}
        
        let gradientView = GradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.startColor = UIColor("#1A1B22", alpha: 0)
        gradientView.endColor = UIColor("#1A1B22", alpha: 60)
        contentView.addSubview(gradientView)
        
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: cellImageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.gradientView = gradientView
    }
    
    func configureCellDateLabel() {
        guard let cellImageView = cellImageView else {return}
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: cellImageView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: -8)
        ])
        
        self.cellDateLabel = label
    }
}
