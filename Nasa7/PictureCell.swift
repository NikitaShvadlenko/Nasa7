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
    // Как didset работает вложенная в lazy var? в каком порядке идет этот код?
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
    }
    func configure(model: ApodModel, delegate: PictureCellDelegate) {
        self.delegate = delegate
        loadImage(url: model.url)
    }
    func loadImage(url: URL) {
        imageProvider.request(.image(url: url)) { [weak self] result in
            guard let self = self else { return }
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
                    // swiftlint:disable:next line_length
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
        imageOfTheWeek.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
