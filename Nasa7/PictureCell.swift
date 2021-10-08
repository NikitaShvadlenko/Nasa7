//
//  PictureCell.swift
//  AbsolutelyNewNasa
//
//  Created by Nikita Shvad on 26.09.2021.
//

import UIKit
import SnapKit
import Moya
protocol PictureCellDelegate: AnyObject {
    // Зачем Этот протокол?
    func pictureCell(_ pictureCell: PictureCell, needsUpdateWith closure:() -> Void)
}
class PictureCell: UITableViewCell {
    private lazy var imageOfTheWeek: UIImageView = {
        let imageOfTheWeek = UIImageView()
        imageOfTheWeek.backgroundColor = .yellow
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
    // в каком порядке идет этот код? Откуда он берет oldValue
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
        imageOfTheWeek.image = nil
        aspectRatioConstraint = nil
        setActivityIndicatorHidden(true)
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
        setActivityIndicatorHidden(false)
        imageProvider.request(.image(url: url)) { [weak self] result in
            guard let self = self else { return }
            self.setActivityIndicatorHidden(true)
            switch result {
            case let .success(response):
                do {
                    let image = try response.mapImage()
                    // Зачем этот код?
                    self.delegate?.pictureCell(self, needsUpdateWith: {
                        [weak self] in
                        guard let self = self else {return}
                    self.imageOfTheWeek.image = image
                        let aspectRatio = image.size.height / image.size.width
                        let aspectRatioConstraint = self.imageOfTheWeek.heightAnchor.constraint(equalTo: self.imageOfTheWeek.widthAnchor, multiplier: aspectRatio)
                        self.aspectRatioConstraint = aspectRatioConstraint
                        self.imageOfTheWeek.image = image
                    })
                } catch {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
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
            make.height.greaterThanOrEqualTo(60)
        }
        
        activityIndicatorContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(imageOfTheWeek)
        }
    }
}
