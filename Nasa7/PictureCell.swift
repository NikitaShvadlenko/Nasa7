//
//  PictureCell.swift
//  AbsolutelyNewNasa
//
//  Created by Nikita Shvad on 26.09.2021.
//

import UIKit
import SnapKit
import Moya

class PictureCell: UITableViewCell {
    
    private lazy var imageOfTheWeek: UIImageView = {
        let imageOfTheWeek = UIImageView()
        imageOfTheWeek.backgroundColor = .yellow
        return imageOfTheWeek
    }()
    
    // Как человеческим языком это можно прочитать? Как только  этой переменной установлено было значение, imageoftheweek убирает старые констрейнты и ставятся новые. Но как вообще didset работает вложенная в lazy var? в каком порядке идет этот код? 
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
    //Откуда NASA image route Берет данные OpenNasaRoute?
    
    let imageProvider = MoyaProvider<NasaImageRoute>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PictureCell {
    func setupView()  {
        contentView.addSubview(imageOfTheWeek)
        imageOfTheWeek.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
            func loadImage(url:URL) {
                imageProvider.request(.image(url: url)) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case let .success(response):
                        do  {
                            let image = try response.mapImage()
                            self.imageOfTheWeek.image = image
                            let aspectRatio = image.size.height / image.size.width
                            let aspectRatioConstraint = self.imageOfTheWeek.heightAnchor.constraint(equalTo: self.imageOfTheWeek.widthAnchor, multiplier: aspectRatio)
                            self.aspectRatioConstraint = aspectRatioConstraint
                        }
                        catch {
                            print(error)
                        }
                    case let .failure(error):
                        print(error)
                        
                    }
                }
            }
        }
    }
}
