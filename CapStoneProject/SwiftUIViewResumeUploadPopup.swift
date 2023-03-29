//
//  SwiftUIViewResumeUploadPopup.swift
//  CapStoneProject
//
//  Created by Junne Murdock on 3/14/23.
//

import SwiftUI



struct SwiftUIViewResumeUploadPopup: View {
    
    @State private var resumeUploadTextView = ""
    @State private var savedResumeUploadText = ""
    @State private var isSaved = false
 
    
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $resumeUploadTextView)
                    .background(Color(red: 218/255, green: 205/255, blue: 205/255))
                
                Spacer()
            }
            .navigationTitle("Resume Upload")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Handle save button tap here
                        savedResumeUploadText = resumeUploadTextView
                        isSaved = true
                    }) {
                        Text("Save")
                    }
                }
            }
            .onDisappear(){
                if isSaved {
                }
            }
            .background(NavigationLink(
                            destination: UploadedResumeViewController(resume: resumeUploadTextView),
                            isActive: $isSaved
                        ) {
                            EmptyView()
                        })
                    }
            
        }
    }
    struct SwiftUIViewResumeUploadPopup_Previews: PreviewProvider {
        static var previews: some View {
            SwiftUIViewResumeUploadPopup()
        }
    }
struct UploadedResumeViewController: View {
    let resume: String
    
    var body: some View {
        Text("Resume: \(resume)")
    }
}
