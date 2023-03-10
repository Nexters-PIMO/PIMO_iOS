//
//  FeedStore.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/24.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import ComposableArchitecture

struct FeedStore: ReducerProtocol {
    struct State: Equatable, Identifiable {
        @BindingState var textImage: TextImage = TextImage.EMPTY
        var id: Int = 0
        var feed: Feed = Feed.EMPTY
        var isFirstFeed: Bool = false
        var clapCount: Int = 0
        var plusClapCount: Int = 0
        var isClapped: Bool = false
        var clapButtonDidTap: Bool = false
        var isClapPlusViewShowing: Bool = false
        var audioButtonDidTap: Bool = false
        var closeButtonDidTap: Bool = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case checkTextGuideClosed
        case moreButtonDidTap(Int)
        case copyButtonDidTap(String)
        case closeButtonDidTap
        case clapButtonDidTap
        case clapButtonIsDone
        case shareButtonDidTap
        case audioButtonDidTap(String)
    }
    
    private enum FeedID { }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .checkTextGuideClosed:
                guard let isClosed = UserUtill.shared.getClosedTextGuide() else {
                    state.closeButtonDidTap = false
                    return .none
                }
                state.closeButtonDidTap = isClosed
            case .moreButtonDidTap:
                #warning("바텀시트")
            case .closeButtonDidTap:
                UserUtill.shared.setUserDefaults(key: .closedTextGuide, value: true)
                state.closeButtonDidTap = true
            case .clapButtonDidTap:
                state.plusClapCount += 1
                state.clapCount += 1
                state.clapButtonDidTap = true
                state.isClapPlusViewShowing = true
            case .clapButtonIsDone:
                state.plusClapCount = 0
                state.isClapPlusViewShowing = false
            case .shareButtonDidTap:
                #warning("딥링크")
            case let .audioButtonDidTap(text):
                if state.audioButtonDidTap {
                    TTSUtil.shared.stop()
                } else {
                    TTSUtil.shared.play(text)
                }
                state.audioButtonDidTap.toggle()
                
            default:
                break
            }
            return .none
        }
    }
}
