//
//  PaginatedModel.swift
//  HRAutomation
//
//  Created by Denis Kovalev on 19.11.2022.
//

import Foundation

struct PaginatedModel<T> {
    let data: [T]

    let page: Int
    let pageSize: Int
    let pagesCount: Int
}
