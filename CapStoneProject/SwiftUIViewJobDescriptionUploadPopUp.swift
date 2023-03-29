//
//  SwiftUIViewLoadingPopUp.swift
//  CapStoneProject
//
//  Created by Junne Murdock on 3/13/23.


import SwiftUI


struct SwiftUIViewJobDescriptionUploadPopUp: View {
    @State private var jobDescriptionUploadTextView = ""
    @State private var savedJobDescriptionUploadText = ""
    @State private var isSaved = false

    @State private var isLoading = false
    @State private var extractedKeywords = ""
    @State private var apiCallCompleted = false // track whether the API call has been completed

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $jobDescriptionUploadTextView)
                    .background(Color(red: 218/255, green: 205/255, blue: 205/255))
                
                Spacer()
                
                //Removed Code
//
//                if apiCallCompleted == true{ // show the "Next" button after the API call is completed
//
//                    NavigationLink(
//                        destination: SwiftUIViewResumeUploadPopup(),
//                        label: {
//                            Text("RESUME")
//                        }
//                    )
//
//                }
                
                //Removed code
            }
            .navigationTitle("Job Description Upload")
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
                        Text("Save")

                    }
                }
            }


            .background(NavigationLink(
                destination: UploadedJobDescriptionViewController(jobDescription: savedJobDescriptionUploadText, extractedKeywords: extractedKeywords),
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
    }
}

struct SwiftUIViewJobDescriptionUploadPopup_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIViewJobDescriptionUploadPopUp()
    }
}


struct UploadedJobDescriptionViewController: View {
    @State private var apiCallCompleted = false // track whether the API call has been completed
    let jobDescription: String
    let extractedKeywords: String // add this property to hold the extracted keywords

    var body: some View {
        VStack {
            Text("Job Description: \(jobDescription)")
            Text("Extracted Keywords: \(extractedKeywords)")
                .bold()
            
            if apiCallCompleted { // show the "Next" button if the API call is completed
                            NavigationLink(
                                destination: SwiftUIViewResumeUploadPopup(),
                                label: {
                                    Text("Upload Resume")
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
//        let data = ["model": "text-curie-001",
//                    "prompt": "Extract the keywords from the following job description text:\n\(jobDescriptionUploadTextView)",
//                    "max_tokens": 30,
//                    "temperature": 0, //try 0 to get more reliable
//                    "n": 2
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
                        self.extractedKeywords = text// extract first part "extracted keywords" then parce the other words to csv. (comma separated value) should make it an array to compare from resume
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




















