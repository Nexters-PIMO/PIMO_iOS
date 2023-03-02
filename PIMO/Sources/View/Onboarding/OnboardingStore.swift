//
//  OnboardingStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/14.
//  Copyright © 2023 pimo. All rights reserved.
//

import ComposableArchitecture

struct OnboardingStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var pageType: OnboardingPageType = .one
        @BindingState var showLoginView = false
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case startButtonTapped
        case skipButtonTapped
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .startButtonTapped:
                state.showLoginView = true
                return .none
            case .skipButtonTapped:
                print("skip")
                return .none
            default:
                return .none
            }
        }
    }
}
