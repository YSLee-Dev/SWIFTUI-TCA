//
//  ResultLoadManager.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 6/11/24.
//

import Foundation
import ComposableArchitecture

struct ResultLoadManager: ResultLoadProtocol {
    func querySearch(query: String) -> [String] {
        [
            String(query.shuffled()),
            String(query.shuffled()),
            String(query.shuffled()),
            String(query.shuffled()),
            String(query.shuffled())
        ]
    }
}

struct ResultLoadPreviewManager: ResultLoadProtocol {
    func querySearch(query: String) -> [String] {
        [
            query,
            query
        ]
    }
}
