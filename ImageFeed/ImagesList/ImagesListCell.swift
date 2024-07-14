import UIKit

enum FeedCellImageState {
    case loading
    case error
    case finished(UIImage)
}

final class ImagesListCell: UITableViewCell {
    private weak var cellImageView: UIImageView?
    private weak var cellLikeButton: UIButton?
    private weak var gradientView: UIView?
    private weak var cellDateLabel: UILabel?
    
    weak var delegate: ImagesListCellDelegate?
    
    static let reuseIdentifier = "ImagesListCell"
    private var state: FeedCellImageState
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.state = .loading
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView?.kf.cancelDownloadTask()
        cellLikeButton?.setBackgroundImage(nil, for: .normal)
        cellDateLabel?.text = nil
        gradientView = nil
        gradientView?.layer.sublayers?.removeAll()
        cellImageView?.layer.sublayers?.removeAll()
        cellImageView?.image = nil
        state = .loading
    }
    
    override func layoutSubviews() {
        switch state {
        case .loading:
            cellImageView?.addCustomGradientForCell()
        case .error: break
            
        case .finished(_): break
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(urlForDownloadImage: URL, date: String, isLiked: Bool) {
        
        cellImageView?.kf.setImage(with: urlForDownloadImage) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let value):
                configureGradientView()
                configureCellDateLabel()
                state = .finished(UIImage())
                cellImageView?.image = value.image
                self.cellDateLabel?.backgroundColor = UIColor.clear
                self.cellDateLabel?.text = date
                let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
                self.cellLikeButton?.setBackgroundImage(likeImage, for: .normal)
                cellImageView?.layer.sublayers?.removeAll()
            case .failure(_):
                state = .error
                cellImageView?.image = UIImage(named: "Stub_card")
                cellImageView?.layer.sublayers?.removeAll()
            }
        }
    }
    
    func setIsLiked(isLikedUpdate: Bool) {
        let likeImage = isLikedUpdate ? UIImage(named: "like_button_off") : UIImage(named: "like_button_on")
        cellLikeButton?.setBackgroundImage(likeImage, for: .normal)
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
        button.addTarget(self, action: #selector(self.didTapLikeButton), for: .touchUpInside)
        
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: cellImageView.topAnchor),
            button.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor),
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        self.cellLikeButton = button
    }
    
    @objc func didTapLikeButton() {
        animateLikeButtonTap()
        delegate?.imageListCellDidTapLike(self)
        
    }
    
    func animateLikeButtonTap() {
        UIView.animate(withDuration: 0.6, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                self.cellLikeButton?.transform = CGAffineTransform(scaleX: 2, y: 2)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2) {
                self.cellLikeButton?.transform = .identity
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2) {
                self.cellLikeButton?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2) {
                self.cellLikeButton?.transform = .identity
            }
        }
    }
    
    func configureGradientView() {
        guard let cellImageView = cellImageView else {return}
        
        let gradientView = GradientView(startColor: UIColor("#1A1B22", alpha: 0), endColor: UIColor("#1A1B22", alpha: 80))
        gradientView.translatesAutoresizingMaskIntoConstraints = false
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
