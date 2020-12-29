//
//  ViewModifiers.swift
//  Transformers
//
//  Created by boqian cheng on 2020-12-28.
//

import Foundation
import SwiftUI

struct ResignKeyboardOnDragGesture: ViewModifier {
    
    var gesture = DragGesture().onChanged{ _ in
        UIApplication.shared.endEditing(true)
    }
    
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}
