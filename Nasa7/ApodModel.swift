//
//  ApodModel.swift
//  AbsolutelyNewNasa
//
//  Created by Nikita Shvad on 26.09.2021.
//

import Foundation

// Это я когда уже ответ получу, мне нужно будет из этого ответа достать url картинки.
// А знаю я, что называется ответ url, потому что это при выполнении запроса показывается
// Я тут просто пытаюсь попутно вспомнить, в каком порядке и зачем весь тот код писался

struct ApodModel: Decodable {
    let url: URL
}
