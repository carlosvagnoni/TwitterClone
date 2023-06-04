//
//  TextArea.swift
//  TwitterClone
//
//  Created by user239477 on 6/4/23.
//

import SwiftUI

struct TextArea: View {
    
    let placeholder: String
    
    @Binding var text: String
    
    init(_ placeholder: String, text: Binding<String>) {
        
        self.placeholder = placeholder
        self._text = text
        UITextView.appearance().backgroundColor = .clear
    }

    var body: some View {
        
        ZStack(alignment: .topLeading) {
            
            if text.isEmpty {
                
                Text(placeholder)
                    .foregroundColor(Color(.placeholderText))
                    .padding(12)
                
            }
            
            TextEditor(text: $text)
                .padding(12)
            
        }
        .font(.body)
        
    }
}

struct TextArea_Previews: PreviewProvider {
    
    static var previews: some View {
        
        TextArea("Placeholder", text: .constant(""))
        
    }
}
