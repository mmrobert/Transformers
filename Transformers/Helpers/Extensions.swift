//
//  Extensions.swift
//  Transformers
//
//  Created by boqian cheng on 2020-12-28.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        modifier(ResignKeyboardOnDragGesture())
    }
}
