//
//  ResultLoadProtocol.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 6/11/24.
//

import Foundation

protocol ResultLoadProtocol {
    func querySearch(query: String) async throws-> [String]
}
