//
//  OnboardingView.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/14.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct OnboardingView: View {
    @EnvironmentObject var sceneDelegate: SceneDelegate
    let store: StoreOf<UnAuthenticatedStore>

    var isOverflowBottomText: Bool {
        sceneDelegate.window?.bounds.height ?? .zero * 0.35 < 281
    }

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack(path: viewStore.binding(\.$path)) {
                ZStack {
                    Color.white
                        .ignoresSafeArea()

                    TabView(selection: viewStore.binding(\.$pageType)) {
                        ForEach(OnboardingPageType.allCases, id: \.self) { type in
                            ZStack {
                                VStack(spacing: 0) {
                                    VStack {
                                        Spacer()

                                        if viewStore.pageType != .one {
                                            viewStore.pageType.backgroundImage
                                                .resizable()
                                                .frame(maxHeight: .infinity)
                                                .padding(.top, 40)
                                                .aspectRatio(contentMode: .fit)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(
                                        viewStore.pageType == .one
                                        ? Color.clear
                                        : Color(PIMOAsset.Assets.gray1.color)
                                    )

                                    VStack(alignment: .leading, spacing: 0) {
                                        if viewStore.pageType == .one {
                                            Image(uiImage: PIMOAsset.Assets.logo.image)
                                                .padding(.leading, 40)
                                                .padding(.bottom, -20)
                                        }

                                        VStack(spacing: 0) {
                                            OnboardingDescriptionView(type: type)

                                            Spacer()

                                            if viewStore.pageType == .four {
                                                startButton(viewStore: viewStore)
                                            } else {
                                                Rectangle()
                                                    .foregroundColor(.clear)
                                                    .frame(width: 313, height: 56)
                                                    .padding(.bottom, 60)
                                            }
                                        }
                                        .if(isOverflowBottomText) { view in
                                            view.frame(height: 281)
                                        }

                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .ignoresSafeArea()
                                    .background(
                                        viewStore.pageType == .one
                                        ? Color.clear
                                        : Color.white
                                    )
                                }
                            }
                            .ignoresSafeArea()
                            .tag(type)
                        }
                    }
                    .ignoresSafeArea()
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .background(
                        viewStore.pageType.backgroundImage
                            .resizable()
                            .ignoresSafeArea()
                            .scaledToFill()
                    )

                    if viewStore.pageType != .four {
                        ZStack {
                            skipButton(viewStore: viewStore)

                            indexDisplay(viewStore: viewStore)
                        }
                        .transition(.opacity)
                        .animation(.easeInOut, value: viewStore.pageType)
                        .zIndex(1)
                    }
                }
                .ignoresSafeArea()
                .zIndex(0)
                .navigationDestination(for: UnauthenticatedScene.self) { scene in
                    switch scene {
                    case .login:
                        LoginView(
                            store: store.scope(
                                state: \.loginState,
                                action: { UnAuthenticatedStore.Action.login($0) }
                            )
                        )
                    case .nickName:
                        NicknameSettingView(
                            store: store.scope(
                                state: \.profileSettingState,
                                action: { UnAuthenticatedStore.Action.profileSetting($0) }
                            )
                        )
                    case .archiveName:
                        ArchiveSettingView(
                            store: store.scope(
                                state: \.profileSettingState,
                                action: { UnAuthenticatedStore.Action.profileSetting($0) }
                            )
                        )
                    case .profilePicture:
                        ProfilePictureSettingView(
                            store: store.scope(
                                state: \.profileSettingState,
                                action: { UnAuthenticatedStore.Action.profileSetting($0) }
                            )
                        )
                    case .complete:
                        CompleteSettingView(
                            store: store.scope(
                                state: \.profileSettingState,
                                action: { UnAuthenticatedStore.Action.profileSetting($0) }
                            )
                        )
                    default:
                        EmptyView()
                    }
                }
            }
        }
    }

    func startButton(viewStore: ViewStore<UnAuthenticatedStore.State, UnAuthenticatedStore.Action>) -> some View {
        VStack(alignment: .center) {
            Button {
                viewStore.send(.startButtonTapped)
            } label: {
                HStack(spacing: 0) {
                    Image(uiImage: PIMOAsset.Assets.simpleLogo.image)
                        .resizable()
                        .frame(width: 30, height: 20)

                    Text("피모 시작하기")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(14)

                }
                .frame(width: 313, height: 56)
                .background(Color.black)
                .cornerRadius(4)
            }
            .padding(.bottom, 60)
        }
    }

    func skipButton(viewStore: ViewStore<UnAuthenticatedStore.State, UnAuthenticatedStore.Action>) -> some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    viewStore.send(.skipButtonTapped)
                } label: {
                    Text("SKIP")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color(PIMOAsset.Assets.red1.color))
                }
                .padding(.top, 20 + (sceneDelegate.window?.safeAreaInsets.top ?? .zero))
                .padding(.trailing, 20 + (sceneDelegate.window?.safeAreaInsets.right ?? .zero))
            }
            Spacer()
        }
    }

    func indexDisplay(viewStore: ViewStore<UnAuthenticatedStore.State, UnAuthenticatedStore.Action>) -> some View {
        VStack {
            Spacer()
            HStack(spacing: 4) {
                ForEach(OnboardingPageType.allCases, id: \.self) {
                    Capsule()
                        .fill($0 == viewStore.pageType ? Color(PIMOAsset.Assets.red1.color) : Color(PIMOAsset.Assets.gray1.color))
                        .frame(width: $0 == viewStore.pageType ? 18 : 8, height: 6)
                        .animation(.easeInOut, value: viewStore.pageType)
                }
                Spacer()
            }
            .padding(.leading, 40)
            .padding(.bottom, 60)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(
            store: Store(
                initialState: UnAuthenticatedStore.State(),
                reducer: UnAuthenticatedStore()
            )
        )
    }
}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
