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
    
    @FocusState private var isFocused: Bool
    
    init(_ placeholder: String, text: Binding<String>) {
        
        self.placeholder = placeholder
        self._text = text

    }

    var body: some View {
        
        ZStack(alignment: .topLeading) {
            
            TextEditor(text: $text)
                .padding(4)
                .focused($isFocused)
                .frame(minHeight: 50)
                .fixedSize(horizontal: false, vertical: true)
            
            if text.isEmpty {

                Text(placeholder)
                    .foregroundColor(Color(.gray))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
                    .background(.clear)
                    

            }
  
        }
        .font(.body)
        .onAppear {
                    isFocused = true
                }
        
    }
}

struct TextArea_Previews: PreviewProvider {
    
    static var previews: some View {
        
        TextArea("Placeholder", text: .constant(""))
        
    }
}
