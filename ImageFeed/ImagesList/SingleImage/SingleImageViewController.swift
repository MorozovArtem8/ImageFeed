import UIKit

final class SingleImageViewController: UIViewController {
    private weak var singleImageView: UIImageView?
    private weak var scrollView: UIScrollView?
    private weak var backButton: UIButton?
    private weak var sharedButton: UIButton?
    
    private var currentImageZoomScale: CGFloat = 0 // Переменная для хранения параметра дефолтного скейла конкретной картинки (для функции зума по двойному тапу возвращаем в исходное состояние после увеличения)
    var image: UIImage? {
        didSet {
            guard isViewLoaded else {return}
            guard let image else {return}
            singleImageView?.image = image
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
        configureUI()
        
        
    }
    
    private func configureScrollViewSettings() {
        guard let image,
              let singleImageView else {return}
        
        singleImageView.image = image
        singleImageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
        
        singleImageView.addGestureRecognizer(zoomingTap)
        singleImageView.isUserInteractionEnabled = true
    }
    
    @objc private func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        zoom(point: location, animated: true)
    }
    
    private func zoom(point: CGPoint, animated: Bool) {
        guard let currentScale = self.scrollView?.zoomScale,
              let maxScale = self.scrollView?.maximumZoomScale else {return}
        
        if currentImageZoomScale >= maxScale && currentScale >= maxScale { // Если картинка по умолчанию маленькая и растянута на весь экран то ее невозможно увеличить дабл тапом
            return
        }
        
        let finalScale = (currentScale == maxScale) ? currentImageZoomScale : maxScale
        let zoomRect = zoomRect(scale: finalScale, canter: point)
        scrollView?.zoom(to: zoomRect, animated: true)
    }
    
    private func zoomRect(scale: CGFloat, canter: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        guard let bounds = scrollView?.bounds else {return CGRect()}
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        
        zoomRect.origin.x = canter.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = canter.y - (zoomRect.size.height / 2)
        return zoomRect
    }
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let scrollViewSize = scrollView.bounds.size
        let xOffset = max((scrollViewSize.width - scrollView.contentSize.width) / 2, 0)
        let yOffset = max((scrollViewSize.height - scrollView.contentSize.height) / 2, 0)
        scrollView.contentInset = UIEdgeInsets(top: yOffset, left: xOffset, bottom: 0, right: 0)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        guard let scrollView else {return}
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
    
}

//MARK: Configure UI
private extension SingleImageViewController {
    func configureUI() {
        view.backgroundColor = .ypBlack
        configureScrollView()
        configureSingleImageView()
        configureBackButton()
        configureSharedButton()
    }
    
    func configureScrollView() {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypBlack
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.2
        scrollView.maximumZoomScale = 1.25
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        ])
        self.scrollView = scrollView
    }
    
    func configureSingleImageView() {
        guard let scrollView else {return}
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        self.singleImageView = imageView
        configureScrollViewSettings()
    }
    
    func configureBackButton() {
        let exitButtonImage = UIImage(named: "Backward")
        let button = UIButton()
        button.addTarget(self, action: #selector(self.didTapBackButton), for: .touchUpInside)
        button.setImage(exitButtonImage ?? UIImage(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            button.widthAnchor.constraint(equalToConstant: 48),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        self.backButton = button
    }
    
    @objc func didTapBackButton() {
        dismiss(animated: true, completion: nil)
        
    }
    
    func configureSharedButton() {
        let sharedButtonImage = UIImage(named: "Sharing")
        let button = UIButton()
        button.addTarget(self, action: #selector(self.didTapSharedButton), for: .touchUpInside)
        button.setImage(sharedButtonImage ?? UIImage(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            button.widthAnchor.constraint(equalToConstant: 51),
            button.heightAnchor.constraint(equalToConstant: 51)
        ])
        
        self.backButton = button
    }
    
    @objc func didTapSharedButton() {
        guard let image else {return}
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true)
        
    }
}
