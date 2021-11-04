//
//  OpenNasaRoute.swift
//  AbsolutelyNewNasa
//
//  Created by Nikita Shvad on 26.09.2021.
//

import Foundation
import Moya

enum OpenNasaRoute {
    case apod (start_date: String,
               end_date: String)
}

extension OpenNasaRoute: TargetType {
    var baseURL: URL {
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
        case let .apod(start_date, end_date):
            let parameters: [String: Any] = [
                "api_key": "2Mito0IFexJK9pmjgAQyRVy6WpMvJLokRCchXi7i",
                "start_date": start_date,
                "end_date": end_date
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    var headers: [String: String]? {
        return nil
    }
}
