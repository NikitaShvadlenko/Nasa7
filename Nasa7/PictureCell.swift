//
//  PictureCell.swift
//  AbsolutelyNewNasa
//
//  Created by Nikita Shvad on 26.09.2021.
//
import AVFoundation
import UIKit
import SnapKit
import Moya

let cacheProvider = CacheProvider()

protocol PictureCellDelegate: AnyObject {
    // Зачем Этот протокол?
    func pictureCell(_ pictureCell: PictureCell, needsUpdateWith closure:() -> Void)
}

class PictureCell: UITableViewCell {

    
    
    private lazy var imageOfTheWeek: UIImageView = {
        let imageOfTheWeek = UIImageView()
        imageOfTheWeek.backgroundColor = .yellow
        imageOfTheWeek.contentMode = .scaleToFill
        imageOfTheWeek.clipsToBounds = true
        return imageOfTheWeek
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .white
        indicator.style = .large
        return indicator
    }()
    
    private lazy var activityIndicatorContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        view.layer.cornerRadius = 4
        view.isHidden = true
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        return view
    }()
    
    private var aspectRatioConstraint: NSLayoutConstraint? {
        didSet {
            if let oldConstraint = oldValue {
                imageOfTheWeek.removeConstraint(oldConstraint)
            }
            if let newConstraint = aspectRatioConstraint {
                newConstraint.isActive = true
            }
        }
    }
    
    private weak var delegate: PictureCellDelegate?
    // Откуда NASA image route Берет данные OpenNasaRoute?
    let imageProvider = MoyaProvider<NasaImageRoute>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        aspectRatioConstraint = nil
        setActivityIndicatorHidden(true)
        imageOfTheWeek.image = nil
    }
    
    func configure(model: ApodModel, delegate: PictureCellDelegate) {
        self.delegate = delegate
        loadImage(url: model.url)
    }
    
    func setActivityIndicatorHidden (_ hidden: Bool) {
        activityIndicatorContainer.isHidden = hidden
        if hidden {
            activityIndicator.stopAnimating()
        }
        else {
            activityIndicator.startAnimating()
        }
    }
    
    func loadImage(url: URL) {
        
        if let imageData = cacheProvider.retrieve(key: url.absoluteString) {
            let image = UIImage(data: imageData)
            imageOfTheWeek.image = image
            print("image retrieved from cache")
            setActivityIndicatorHidden(true)
            return
        }
        
        setActivityIndicatorHidden(false)
        imageProvider.request(.image(url: url)) { [weak self] result in
            
            guard let self = self else { return }
            self.setActivityIndicatorHidden(true)
            
            DispatchQueue.global(qos: .userInitiated).async {
                switch result {
                case let .success(response):
                    do {
                        let image = try response.mapImage()
                        let size = CGSize(width: image.size.width, height: image.size.width)
                        let downsampledImage = self.resizedImage(image: image, for: size)
                        guard let safeImage = downsampledImage else {return}
                        cacheProvider.save(key: url.absoluteString, value: (safeImage.pngData())!)
                        print("Image ?was saved to cahce")
                        DispatchQueue.main.async {
                            self.imageOfTheWeek.image = downsampledImage
                        }
                    } catch {
                        print(error)
                    }
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    func resizedImage(image: Image, for size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

private extension PictureCell {
    func setupView() {
        contentView.addSubview(imageOfTheWeek)
        contentView.addSubview(activityIndicatorContainer)
        activityIndicatorContainer.addSubview(activityIndicator)
        imageOfTheWeek.snp.makeConstraints { (make: ConstraintMaker) in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().inset(4).priority(.high)
            make.height.equalTo(imageOfTheWeek.snp.width)
        }
        
        activityIndicatorContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(imageOfTheWeek)
        }
    }
}
