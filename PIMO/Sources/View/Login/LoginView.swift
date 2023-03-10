//
//  ContentView.swift
//  PIMO
//
//  Created by 김영인 on 2023/01/20.
//  Copyright © 2023 PIMO. All rights reserved.
//

import AuthenticationServices
import SwiftUI
import UIKit

import ComposableArchitecture

struct LoginView: View {
    @EnvironmentObject var sceneDelegate: SceneDelegate
    let store: StoreOf<LoginStore>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Image(uiImage: PIMOAsset.Assets.onboardingBackgroundOne.image)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Text("글사진 아카이브 플랫폼")
                        .font(Font(PIMOFontFamily.Pretendard.regular.font(size: 15)))
                        .foregroundColor(.white)
                        .opacity(0.6)
                        .padding(.bottom, 17)
                    Image(uiImage: PIMOAsset.Assets.appLogo.image)
                        .renderingMode(.original)
                        .scaledToFit()
                        .frame(width: 200, height: 40)
                    Spacer()
                    Text("SNS 계정으로 간편 가입하기")
                        .font(Font(PIMOFontFamily.Pretendard.medium.font(size: 14)))
                        .foregroundColor(.white)
                        .padding(.top, 0)
                        .padding(.bottom, 18)
                    Button {
                        viewStore.send(.tappedKakaoLoginButton)
                    } label: {
                        Image(uiImage: PIMOAsset.Assets.kakaoLoginMediumWide.image)
                            .resizable()
                            .renderingMode(.original)
                            .scaledToFill()
                            .cornerRadius(8)
                    }
                    .frame(width: 360, height: 54)
                    .padding(.top, 0)
                    .padding(.bottom, 18)
                        
                    AppleLoginButton(
                        viewStore: viewStore,
                        window: sceneDelegate.window!,
                        title: "Apple로 로그인",
                        action: {
                            viewStore.send(.tappedAppleLoginButton)
                        })
                    .alert("로그인이 실패했습니다", isPresented: viewStore.$isAlertShowing) {
                        Button("확인", role: .cancel) {
                            viewStore.send(.tappedAlertOKButton)
                        }
                    }
                    .cornerRadius(8)
                    .frame(width: 360, height: 54)
                    .padding(.top, 0)
                    .padding(.bottom, 50)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            store: Store(
                initialState: LoginStore.State(),
                reducer: LoginStore()
            )
        )
    }
}
