import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private init() {}
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animationType = .circleRotateChase
        ProgressHUD.colorHUD = .clear
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.animationType = .circleRotateChase
        ProgressHUD.colorHUD = .clear
        ProgressHUD.dismiss()
    }
}
