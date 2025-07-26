//
//  NumberOnlyTextField.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/26/25.
//

import SwiftUI
import AppKit

struct NumberOnlyTextField: NSViewRepresentable {
    @Binding var value: Int?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField(string: "")
        textField.delegate = context.coordinator
        textField.isBezeled = false
        textField.drawsBackground = false
        textField.isEditable = true
        textField.isSelectable = true
        textField.focusRingType = .none
        textField.alignment = .center
        textField.textColor = .white

        // 숫자만 허용하는 NumberFormatter
        let formatter = NumberFormatter()
        formatter.minimum = 0
        formatter.maximum = 999
        formatter.allowsFloats = false
        formatter.numberStyle = .none
        textField.formatter = formatter

        return textField
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        if let value = value {
            nsView.stringValue = "\(value)"
        } else {
            nsView.stringValue = ""
        }
    }

    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: NumberOnlyTextField

        init(_ parent: NumberOnlyTextField) {
            self.parent = parent
        }

        func controlTextDidChange(_ obj: Notification) {
            if let textField = obj.object as? NSTextField {
                let text = textField.stringValue
                if let intValue = Int(text) {
                    parent.value = intValue
                } else {
                    parent.value = nil
                }
            }
        }
    }
}
