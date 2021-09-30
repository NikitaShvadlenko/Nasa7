//
//  NasaImageRoute.swift
//  AbsolutelyNewNasa
//
//  Created by Nikita Shvad on 26.09.2021.
//
import Foundation
//Почему Moya не содержит в себе Foundation, как, например, UIKIT?
import Moya

enum NasaImageRoute {
    case image(url: URL)
}

extension NasaImageRoute: TargetType {
    var baseURL: URL {
        switch self {
        //Почему case let? Я помню, что это делается для создания полной короткой ссылки, но не понимаю, что именно я тут делаю.
        case let .image(url):
            return url
        }
    }
    
    var path: String {
        ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
