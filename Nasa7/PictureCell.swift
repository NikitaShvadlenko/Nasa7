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
   
    private lazy var imageOfTheWeek: UIView = {
        let imageOfTheWeek = UIView()
        imageOfTheWeek.backgroundColor = .yellow
        return imageOfTheWeek
    }()
    
    //Предположу, что MoyaProvider просто помогает проще делать try и все такие вещи, связанные с реквестом
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
            //Я должен как-то связать NasaImageRoute и OpenNasaRoute Почему url:url?
            imageProvider.request(.image(url: url)) { <#Result<Response, MoyaError>#> in
                <#code#>
            }
        }
    }
}
