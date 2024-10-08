import Foundation
import UIKit

final class CatCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    
    
    private let service = ImageService.shared
    
    private var task: URLSessionDataTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
    }
    
    func setupData(urlString: String, detail: Bool = false) {
        task?.cancel()
        self.imageView.image = nil
        if detail {
            self.imageView.contentMode = .scaleAspectFit
        }
        task = service.setImage(view: self.imageView, urlString: urlString)
    }
    
 
}
