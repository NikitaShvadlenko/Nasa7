//
//  OpenNasaRoute.swift
//  AbsolutelyNewNasa
//
//  Created by Nikita Shvad on 26.09.2021.
//

import Foundation
import Moya

//Enum тут на случай, если я захочу чем-нибудь еще воспользоваться из наса АПИ
enum OpenNasaRoute {
    case apod
}

extension OpenNasaRoute: TargetType {
    
    var baseURL: URL {
        //Как URL Вобще может быть Optional, если я туда Литерал пишу?
        URL(string: "https://api.nasa.gov/planetary/")!
    }
    
    var path: String {
        switch self {
        case .apod:
            return "apod"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .apod:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .apod:
            let parameters: [String: Any] = [
                "api_key": "DEMO_KEY"
            ]
            // не запомнил, но понимаю, почему тут такой тип кодировки.
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}

