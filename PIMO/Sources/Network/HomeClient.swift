//
//  HomeService.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/26.
//  Copyright © 2023 pimo. All rights reserved.
//

import Combine
import Foundation

import ComposableArchitecture

struct HomeClient {
    let fetchFeeds: () -> [Feed]
}

extension DependencyValues {
    var homeClient: HomeClient {
        get { self[HomeClient.self] }
        set { self[HomeClient.self] = newValue }
    }
}

extension HomeClient: DependencyKey {
    static let liveValue = Self.init (
        fetchFeeds: {
            // TODO: 서버 통신
            return Temp.feeds
        }
    )
}
