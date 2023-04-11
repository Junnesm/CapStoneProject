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
//        NavigationView {
            
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
                                .ignoresSafeArea()
                    )
                Spacer()
            }
            .navigationTitle("Resume Upload")
//            .navigationBarTitleDisplayMode(.automatic)
            .font(.custom("Helvetica-Bold", size: 40))
//            .foregroundColor(.black)
            
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Spacer()
                }

                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        keywordStore.savedResumeUploadText = resumeUploadTextView.components(separatedBy: " ")
                        similarity = Double(calculateSimilarity(text: keywordStore.savedResumeUploadText, extractedKeywords: keywordStore.descriptionKeywords))
                        isSaved = true
                    }) {
                        Text("Calculate Match")
                            .font(.custom("Helvetica-Bold", size: 20))
                            .foregroundColor(.black)
                    }
                }
            }

//            .toolbar {
//                ToolbarItemGroup(placement: .navigationBarLeading) {
//                    Button(action: {
//                        keywordStore.savedResumeUploadText = resumeUploadTextView.components(separatedBy: " ")
//                        similarity = Double(calculateSimilarity(text: keywordStore.savedResumeUploadText, extractedKeywords: keywordStore.descriptionKeywords))
//
//                        isSaved = true
//                    }) {
//                        Text("Calculate")
//                            .font(.custom("Helvetica-Bold", size: 15))
//                            .foregroundColor(.black)
//                    }
//
//                }
//            }
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

struct UploadedResumeViewController: View {
    let resume: String
    let similarity: Double
    
    var body: some View {
        VStack {
            Text("Resume: \(resume)")
            Text("Similarity score: \(formatPercentage(similarityPercentage: Int(similarity)))")
        }
    }
}

func calculateSimilarity(text: [String], extractedKeywords: [String]) -> Int {
    let textTokens = tokenize(text.joined(separator: " "))
    let keywordTokens = tokenize(extractedKeywords.joined(separator: " "))
    let overlap = Set(textTokens).intersection(Set(keywordTokens))

    // Find words in "text" that are also in extracted keywords
    let relevantTextTokens = textTokens.filter { keywordTokens.contains($0) }

    let similarity = Double(overlap.count) / Double(relevantTextTokens.count)
    let similarityPercentage = Int(similarity * 100.0)

    return similarityPercentage

}
func formatPercentage(similarityPercentage: Int) -> String {
    return "\(similarityPercentage)%"
}

func tokenize(_ text: String) -> [String] {
    let tokenizer = NLTokenizer(unit: .word)
    tokenizer.string = text
    let tokens = tokenizer.tokens(for: text.startIndex..<text.endIndex)
    return tokens.map { String(text[$0]) }
}

