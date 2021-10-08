//
//  OpenNasaRoute.swift
//  AbsolutelyNewNasa
//
//  Created by Nikita Shvad on 26.09.2021.
//

import Foundation
import Moya

// Enum тут на случай, если я захочу чем-нибудь еще воспользоваться из наса АПИ
enum OpenNasaRoute {
    case apod (start_date: String,
               end_date: String)
}

extension OpenNasaRoute: TargetType {
    var baseURL: URL {
        // Как URL Вобще может быть Optional, если я туда Литерал пишу?
        // Потому что при инициализации var всегда будет nil.
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
        // Опять использую case let потому что я тут СОЗДАЮ аргумент функции
        case let .apod(start_date, end_date):
            let parameters: [String: Any] = [
                "api_key": "DEMO_KEY",
                "start_date": start_date,
                "end_date": end_date
            ]
            // не запомнил, но понимаю, почему тут такой тип кодировки.
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    var headers: [String: String]? {
        return nil
    }
}
