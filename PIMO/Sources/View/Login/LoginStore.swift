//
//  LoginStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import AuthenticationServices
import Combine
import Foundation

import ComposableArchitecture
import KakaoSDKUser

struct LoginStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var isAlertShowing = false
        var isSignIn = false
        var errorMessage = ""
        var appleIdentityToken = ""
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case tappedKakaoLoginButton
        case tappedAppleLoginButton(String)
        case showAlert
        case showToast
        case tappedAlertOKButton
        case tappedAppleLoginButtonDone(Result<AppleLogin, NetworkError>)
        case encodeTokenDone(Result<EncodeLogin, NetworkError>)
    }
    
    @Dependency(\.loginClient) var loginClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .tappedAppleLoginButton(let token):
                guard token != "" else {
                    return .none
                }
                
                state.appleIdentityToken = token
                
                return loginClient.getAppleLoginToken(token)
                    .map { result in
                        return Action.tappedAppleLoginButtonDone(result)
                    }
            case .tappedAppleLoginButtonDone(let result):
                switch result {
                case .success(let appleLogin):
                    guard let accessToken = appleLogin.data?.accessToken else {
                        return .none
                    }
                    
                    return loginClient.encodeAppleLoginToken(accessToken)
                        .map { result in
                            return Action.encodeTokenDone(result)
                        }
                case .failure:
                    return .init(value: Action.showToast)
                }
            case .tappedKakaoLoginButton:
                var errorMessage = ""
                var isSignIn = false
                
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                        if let error {
                            errorMessage = error.localizedDescription
                        } else {
                            isSignIn = true

                            UserUtill.shared.setUserDefaults(key: .token, value: oauthToken?.accessToken)
                        }
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                        if let error = error {
                            errorMessage = error.localizedDescription
                        } else {
                            isSignIn = true

                            UserUtill.shared.setUserDefaults(key: .token, value: oauthToken?.accessToken)
                        }
                    }
                }
                
                state.errorMessage = errorMessage
                state.isSignIn = isSignIn
                
                return .none
            case .encodeTokenDone(let result):
                switch result {
                case .success(let encodeLogin):
                    guard let encodedAccessToken = encodeLogin.data?.accessToken else {
                        return .none
                    }
                    
                    let memberToken = MemberToken(accessToken: encodedAccessToken, refreshToken: nil)
                    UserUtill.shared.setUserDefaults(key: .token, value: memberToken)
                case .failure:
                    return .init(value: Action.showToast)
                }
                
                return .none
            case .showAlert:
                state.isAlertShowing = true
                
                return .none
            case .tappedAlertOKButton:
                state.isAlertShowing = false
                
                return .none
            default:
                return .none
            }
        }
    }
}
