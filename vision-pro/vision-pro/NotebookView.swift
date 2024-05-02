//
//  NotebookView.swift
//  vision-pro
//
//  Created by Bill on 2024-04-30.
//

import SwiftUI

struct NotebookView: View {
    
    @State private var title: String = ""
    @State private var content: String = ""
    
    
    func saveNote() {
            // Handle the saving of the note here
            print("Saving Note with Title: \(title) and Body: \(content)")
        }
    
    
    var body: some View {
        VStack {
            
            TextField("Untitled Note", text: $title)
                .padding(.horizontal, 70)
                .padding(.top, 60)
                .font(Font.system(size: 28))
            
            
            TextEditor(text: $content)
                .padding()
                .padding(.horizontal, 40)
                .frame(height: 300) // You can adjust the height based on your needs
                .cornerRadius(30)
                
                        
            Button("Save") {
                saveNote()
            }
            .padding()
            .cornerRadius(8)
            .padding(.bottom, 40)
                
        }
        .navigationTitle("Notebook")
    }
}



