//
//  Feed.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct Feed: Decodable, Equatable, Hashable {
    let id: Int
    let profile: Profile
    let uploadTime: String
    let textImages: [TextImage]
    let clapCount: Int
    let isClapped: Bool
        
    static var EMPTY: Feed = .init(
        id: 0,
        profile: Profile.EMPTY,
        uploadTime: "",
        textImages: [],
        clapCount: 0,
        isClapped: false
    )
}
