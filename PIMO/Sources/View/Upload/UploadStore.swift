//
//  UploadStore.swift
//  PIMOTests
//
//  Created by 김영인 on 2023/02/14.
//  Copyright © 2023 pimo. All rights reserved.
//

import ComposableArchitecture

struct UploadStore: ReducerProtocol {
    struct State: Equatable { }
    
    enum Action: Equatable {
        case didTapCloseButton
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .didTapCloseButton:
                return .none
            }
        }
    }
}
