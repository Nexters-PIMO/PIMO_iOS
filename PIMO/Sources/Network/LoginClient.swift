//
//  LoginService.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Combine
import Foundation

import ComposableArchitecture

struct LoginClient {
    let appleLogin: (String) -> EffectPublisher<Result<AppleLogin, NetworkError>, Never>
}

extension DependencyValues {
    var loginClient: LoginClient {
        get { self[LoginClient.self] }
        set { self[LoginClient.self] = newValue }
    }
}

extension LoginClient: DependencyKey {
    static let liveValue = Self.init { identityToken in
        let request = AppleLoginRequest(parameters: [
            "state": "apple",
            "code": identityToken
        ])
        let effect = BaseNetwork.shared.request(api: request, isInterceptive: false)
            .catchToEffect()

        return effect
    }
}
