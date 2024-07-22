import UIKit

extension UIView {
    func addCustomGradient(width: CGFloat, height: CGFloat) {
        checkGradientSublayers()
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: width + 1, height: height + 1))
        gradient.locations = [0, 0.1, 0.3]
        
        gradient.colors = [
                    UIColor(red: 0.65, green: 0.65, blue: 0.67, alpha: 1).cgColor,
                    UIColor(red: 0.60, green: 0.60, blue: 0.62, alpha: 1).cgColor,
                    UIColor(red: 0.55, green: 0.55, blue: 0.57, alpha: 1).cgColor
                ]
        
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = self.frame.height / 2
        gradient.masksToBounds = true
        self.layer.addSublayer(gradient)
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.1
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.5, 1]
        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
    }
    
    func addCustomGradientForCell() {
        checkGradientSublayers()
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: self.frame.width, height: self.frame.height))
        gradient.locations = [0, 0.1, 0.3]
        
        gradient.colors = [
                    UIColor(red: 0.65, green: 0.65, blue: 0.67, alpha: 1).cgColor,
                    UIColor(red: 0.60, green: 0.60, blue: 0.62, alpha: 1).cgColor,
                    UIColor(red: 0.55, green: 0.55, blue: 0.57, alpha: 1).cgColor
                ]
        
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 16
        gradient.masksToBounds = true
        self.layer.addSublayer(gradient)
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.1
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.5, 1]
        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
    }
    
    private func checkGradientSublayers() {
        if let sublayers = self.layer.sublayers {
            for sublayer in sublayers {
                if sublayer is CAGradientLayer {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
    }
}

