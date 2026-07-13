//
//  SwiftUIView.swift
//  CasePathable
//
//  Created by Pau Blanes on 13/07/2026.
//

import SwiftUI
import CaseKeyPath

/*
 Goal: Get a binding from an enum case asociated value
 E.g. `$field.number` → Binding<Int> → Stepper edits the Int inside `.number`.
 */


@CasePathable
enum FieldValue {
    case text(String)
    case number(Int)
}

struct FieldView: View {
    @State private var field: FieldValue = .text("Write something")
    
    var body: some View {
        VStack {
            // ✅ Case paths: Simply Binding<Value> from the CaseKeyPath
            if let text = $field.text {
                TextField("Text", text: text)
            }
            if let number = $field.number {
                Stepper("\(number.wrappedValue)", value: number)
            }
            
            // ❌ Vanilla: More verbose, we need to recreate the case every time
            if case let .text(current) = field {
                TextField("Text", text: Binding(
                    get: { if case let .text(s) = field { s } else { current } },
                    set: { field = .text($0) }
                ))
            }
        }
        .padding()
    }
}

#Preview {
    FieldView()
}
