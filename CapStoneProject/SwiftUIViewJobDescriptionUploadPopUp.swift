//
//  SwiftUIViewLoadingPopUp.swift
//  CapStoneProject
//
//  Created by Junne Murdock on 3/13/23.


import SwiftUI
import Foundation

class KeywordStore: ObservableObject {
    @Published var descriptionKeywords: [String] = []
    @Published var savedResumeUploadText: [String]
    
    init() {
        descriptionKeywords = []
        savedResumeUploadText = []
    }
}
struct SwiftUIViewJobDescriptionUploadPopUp: View {
    @State private var jobDescriptionUploadTextView = ""
    @State private var savedJobDescriptionUploadText = ""
    @State private var isSaved = false

    @State private var isLoading = false
    @State var keywordStore: KeywordStore = KeywordStore()
    @State private var apiCallCompleted = false // track whether the API call has been completed

    var body: some View {
        NavigationView {
            
            VStack {
                TextEditor(text: $jobDescriptionUploadTextView)
                    .font(.system(size: 18))
                    .padding()
                    .background(
                        
                            ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(red: 169/255, green: 214/255, blue: 220/255))
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray, lineWidth: 2)
                                    }
                       )
                Spacer()
            }
            .navigationTitle("Job Description Upload")
        
            .font(.custom("Helvetica-Bold", size: 22))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isLoading = true

                        // Simulate a delay to show the loading animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            // Handle save button tap here
                            savedJobDescriptionUploadText = jobDescriptionUploadTextView
                            isSaved = true
                            isLoading = false

                            // Call the API here
                            makeAPICall()
                        }
                    }) {
                        Text("Next")
                            .font(.custom("Helvetica-Bold", size: 15))
                            .foregroundColor(.black)

                    }
                }
            }
            .background(NavigationLink(
                destination: UploadedJobDescriptionViewController(jobDescription: savedJobDescriptionUploadText),
                isActive: $isSaved
            ) {
                EmptyView()
            })
            .overlay(
                Group {
                    if isLoading {
                        ProgressView()
                    }
                }
            )
        }
      
        .environmentObject(keywordStore)
    }
}


struct SwiftUIViewJobDescriptionUploadPopup_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIViewJobDescriptionUploadPopUp()
    }
}


struct UploadedJobDescriptionViewController: View {
    @State private var apiCallCompleted = true // track whether the API call has been completed
    @EnvironmentObject var keywordStore: KeywordStore
    let jobDescription: String

    var body: some View {
        VStack {
            Text("Job Description: \(jobDescription.replacingOccurrences(of: "•", with: ""))")

                .font(.custom("Helvetica-Bold", size: 15))
                .padding(.bottom, 350)
                .listStyle(PlainListStyle())
            Text("Extracted Keywords: \(keywordStore.descriptionKeywords.joined(separator: ","))")
                .font(.custom("Helvetica-Bold", size: 15))
                .bold()
//                .padding(.top, 300)
//
            if apiCallCompleted { // show the "Next" button if the API call is completed
                            NavigationLink(
                                destination: SwiftUIViewResumeUploadPopup(),
                                label: {
                                    Text("Upload Resume")
                                        .font(.custom("Helvetica-Bold", size: 15))
                                        .bold()
                                }
                            )
                        }

            }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        
        
        }
    }


extension SwiftUIViewJobDescriptionUploadPopUp {
    func makeAPICall() {
        let url = URL(string: "https://api.openai.com/v1/completions")!
        let domainKey = "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" ///PUT DOMAIN KEY HERE //make the domain key a environment variable. (to hide when pushing to git)
        let headers = ["Content-Type": "application/json",
                       "Authorization": "Bearer " + domainKey]

        let data = ["model": "text-davinci-003",
                    "prompt": "Extract the keywords from the following job description text:\n\(jobDescriptionUploadTextView)",
                    "max_tokens": 256,
                    "temperature": 0.2
        ] as [String : Any]

        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let choices = json?["choices"] as? [[String: Any]], let text = choices.first?["text"] as? String {
                    DispatchQueue.main.async {
                        self.keywordStore.descriptionKeywords = [text]// extract first part "extracted keywords" then parce the other words to csv. (comma separated value) should make it an array to compare from resume
                        self.apiCallCompleted = true
                        
          
                    }
                } else {
                    print("\(json)")
                }
            } catch {
                print("Error decoding response: \(error.localizedDescription)")
            }

        }.resume()
    }

}




















