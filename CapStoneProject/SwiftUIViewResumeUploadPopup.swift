//
//  SwiftUIViewResumeUploadPopup.swift
//  CapStoneProject
//
//  Created by Junne Murdock on 3/14/23.
//

import SwiftUI
import NaturalLanguage
import Foundation

struct SwiftUIViewResumeUploadPopup: View {
    

    @State private var resumeUploadTextView = ""
    @State private var savedResumeUploadText: [String] = []
    @State private var isSaved = false
    @State private var similarity: Double = 0
    @EnvironmentObject var keywordStore: KeywordStore
    var body: some View {
        NavigationView {
            
            VStack {
                TextEditor(text: $resumeUploadTextView)
                    .font(.system(size: 18))
                    .padding()
                    .background(
                        
                            ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(red: 169/255, green: 214/255, blue: 220/255))
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray, lineWidth: 1)
                                    }
                       )
                Spacer()
            }
            .navigationTitle("Resume Upload")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        keywordStore.savedResumeUploadText = resumeUploadTextView.components(separatedBy: " ") //add what else might need to be added to separate
                        // Calculate similarity between entered text and extracted keywords
                         similarity = calculateSimilarity(text: keywordStore.savedResumeUploadText, extractedKeywords: keywordStore.descriptionKeywords)
                        
                        // Handle save button tap here
                       
                        isSaved = true
                    }) {
                        Text("Calculate")
                    }
                    
                }
            }
            .onDisappear(){
                if isSaved {
                }
            }
            .background(
                NavigationLink(
                destination: UploadedResumeViewController(resume: resumeUploadTextView, similarity: similarity),
                            isActive: $isSaved
                        ) {
                            EmptyView()
                        })
        }
    }
}

struct UploadedResumeViewController: View {
    let resume: String
    let similarity: Double
    
    var body: some View {
        VStack {
            Text("Resume: \(resume)")
            Text("Similarity score: \(String(similarity))")
        }
    }
}

func calculateSimilarity(text: [String], extractedKeywords: [String]) -> Double {

    let textTokens = tokenize(text.joined(separator: " "))
    let keywordTokens = tokenize(extractedKeywords.joined(separator: " "))
    let overlap = Set(textTokens).intersection(Set(keywordTokens))
    let similarity = Double(overlap.count) / Double(textTokens.count)
    return similarity
    
}

func tokenize(_ text: String) -> [String] {
    let tokenizer = NLTokenizer(unit: .word)
    tokenizer.string = text
    let tokens = tokenizer.tokens(for: text.startIndex..<text.endIndex)
    return tokens.map { String(text[$0]) }
}
