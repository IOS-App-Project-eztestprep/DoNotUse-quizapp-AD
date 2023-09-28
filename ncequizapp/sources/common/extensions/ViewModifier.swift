//
//  ViewModifier.swift
//  ncequizapp
//
//  Created by Mahendra Liya on 04/09/23.
//  Copyright © 2023 Mahendra Liya. All rights reserved.
//

import SwiftUI

struct DisableScrollingModifier: ViewModifier {
    enum Direction {
        case vertical
        case horizontal
    }
    
    let direction: Direction
    @State private var draggedOffset: CGSize = .zero
    
    func body(content: Content) -> some View {
            content
            .offset(
                CGSize(width: direction == .vertical ? 0 : draggedOffset.width, height: direction == .horizontal ? 0 : draggedOffset.height)
            )
            .gesture(
                DragGesture()
                .onChanged { value in
                    if(value.translation.width == 0) {
                        self.draggedOffset = value.translation
                    }
                }
                .onEnded { value in
                    self.draggedOffset = .zero
                }
            )
        }
}
