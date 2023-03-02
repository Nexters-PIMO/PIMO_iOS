//
//  SwipeBackDisableView.swift
//  PIMO
//
//  Created by 양호준 on 2023/03/02.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

extension View {
    func disableSwipeBack() -> some View {
        self.background {
            SwipeBackDisableView()
        }
    }
}

struct SwipeBackDisableView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SwipeBackDisableViewController
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        UIViewControllerType()
    }
    
    func updateUIViewController(_ uiViewController: SwipeBackDisableViewController, context: Context) { }
}

final class SwipeBackDisableViewController: UIViewController {
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if let parent = parent,
           let navigationController = parent.navigationController,
           let interactionPopGestureRecognizer = navigationController.interactivePopGestureRecognizer {
            interactionPopGestureRecognizer.isEnabled = false
        }
    }
}
