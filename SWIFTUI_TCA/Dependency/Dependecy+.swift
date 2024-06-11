//
//  Dependecy+.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 6/11/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var resultLoad: ResultLoadProtocol {
        get {self[ResultLoadDependecyKey.self]}
        set {self[ResultLoadDependecyKey.self] = newValue}
    }
}
