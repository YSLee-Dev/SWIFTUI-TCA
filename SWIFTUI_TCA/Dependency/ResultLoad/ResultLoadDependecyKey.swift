//
//  ResultDependecyKey.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 6/11/24.
//

import Foundation
import ComposableArchitecture

enum ResultLoadDependecyKey: DependencyKey {
    static var liveValue: ResultLoadProtocol = ResultLoadManager()
    static var previewValue: ResultLoadProtocol = ResultLoadPreviewManager()
}
