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


    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $jobDescriptionUploadTextView)
                    .background(Color(red: 218/255, green: 205/255, blue: 205/255))

                Spacer()
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
    let jobDescription: String
    let extractedKeywords: String // add this property to hold the extracted keywords

    var body: some View {
        VStack {
            Text("Job Description: \(jobDescription)")
            Text("Extracted Keywords: \(extractedKeywords)")

            }

        }
    }


extension SwiftUIViewJobDescriptionUploadPopUp {
    func makeAPICall() {
        let url = URL(string: "https://api.openai.com/v1/completions")!
        let domainKey = "" ///PUT DOMAIN KEY HERE //make the domain key a environment variable. (to hide when pushing to git)
        let headers = ["Content-Type": "application/json",
                       "Authorization": "Bearer " + domainKey]
        let data = ["model": "text-davinci-003",//text-curie-001 USE THIS INSTEAD
                    "prompt": "Extract the keywords from the following job description text:\n\(jobDescriptionUploadTextView)",
                    "max_tokens": 30,
                    "temperature": 1,
                    "n": 1
//                    "stop": ["\n"]
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
                        self.extractedKeywords = text
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




















