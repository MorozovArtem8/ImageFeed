import UIKit

final class SingleImageViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    private var currentImageZoomScale: CGFloat = 0 // Переменная для хранения параметра дефолтного скейла конкретной картинки (для функции зума по двойному тапу возвращаем в исходное состояние после увеличения)
    var image: UIImage? {
        didSet {
            guard isViewLoaded else {return}
            guard let image else {return}
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    private lazy var zoomingTap: UITapGestureRecognizer = {
        let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
        zoomingTap.numberOfTapsRequired = 2
        return zoomingTap
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollViewSettings()
        
    }
    //MARK: @IBAction func
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton() {
        guard let image else {return}
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true)
    }
    
    private func configureScrollViewSettings() {
        guard let image else {return}
        scrollView.minimumZoomScale = 0.2
        scrollView.maximumZoomScale = 1.25
        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
        
        imageView.addGestureRecognizer(zoomingTap)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc private func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        zoom(point: location, animated: true)
    }
    
    private func zoom(point: CGPoint, animated: Bool) {
        let currentScale = self.scrollView.zoomScale
        let maxScale = self.scrollView.maximumZoomScale
        
        if currentImageZoomScale >= maxScale && currentScale >= maxScale { // Если картинка по умолчанию маленькая и растянута на весь экран то ее невозможно увеличить дабл тапом
            return
        }
        
        let finalScale = (currentScale == maxScale) ? currentImageZoomScale : maxScale
        let zoomRect = zoomRect(scale: finalScale, canter: point)
        scrollView.zoom(to: zoomRect, animated: true)
    }
    
    private func zoomRect(scale: CGFloat, canter: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = scrollView.bounds
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        
        zoomRect.origin.x = canter.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = canter.y - (zoomRect.size.height / 2)
        return zoomRect
    }
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let widthScale = visibleRectSize.width / image.size.width
        let heightScale = visibleRectSize.height / image.size.height
        let scale = min(maxZoomScale, max(minZoomScale, min(widthScale, heightScale)))
        currentImageZoomScale = scale
        scrollView.setZoomScale(scale, animated: true)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
        
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let scrollViewSize = scrollView.bounds.size
        let xOffset = max((scrollViewSize.width - scrollView.contentSize.width) / 2, 0)
        let yOffset = max((scrollViewSize.height - scrollView.contentSize.height) / 2, 0)
        scrollView.contentInset = UIEdgeInsets(top: yOffset, left: xOffset, bottom: 0, right: 0)
    }
    
}

