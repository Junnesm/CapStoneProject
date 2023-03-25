//
//  LinkedInAPI.swift
//  CapStoneProject
//
//  Created by Junne Murdock on 3/8/23.
//


import SwiftUI
import Foundation
import OpenAIKit


struct ChatGPT: Encodable {
    var model: [String: String]
    var messages: [String: String] = [:]

    struct ChatGPTAPI: View {

        @State private var responseText: String = ""
        @State private var jobDescriptionUploadTextView = ""

        var body: some View {
            VStack {
                Text(responseText)
                    .padding()
//                Button("Get Keywords") {
//                    makeAPICall(jobDescription: jobDescriptionUploadTextView)
                Button("Get Keywords") {
                    let jobDescriptionUploadPopup = SwiftUIViewJobDescriptionUploadPopUp()
                    jobDescriptionUploadPopup.makeAPICall()

                }
            }
        }

    }
}








