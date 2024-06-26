import UIKit

final class GradientView: UIView {
    
    var startColor: UIColor? {
        didSet {
            setupGradient()
        }
    }
    var endColor: UIColor? {
        didSet {
            setupGradient()
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 16
        gradientLayer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    private func setupGradient() {
        guard let startColor = startColor, let endColor = endColor else {return}
        
        self.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}
