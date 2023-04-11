//
//  ContentView.swift
//  CapStoneProject
//
//  Created by Junne Murdock on 3/6/23.
//RESUMATE
//THIS IS THE FINAL APP. DO NOT LOOK AT THE OTHERS 


import SwiftUI
import Foundation

    struct ContentView: View {
    
        @State private var isJobDescriptionUploadPresented = false
        @State private var isResumeUploadPresented = false
        @State private var extractedKeywords: [String] = []
        @EnvironmentObject var keywordStore: KeywordStore
    
        var body: some View {
            NavigationView {

                
                ZStack{ // put in zstack for image, vstack for the text over the zstack. the a spacer then an hstack.
                    Image("Blue Gradient Login Page Wireframe Mobile Prototype")
                                 .resizable()
                                 .frame(minWidth: 0, minHeight: 0)
                                 .aspectRatio(contentMode: .fill)
                                 
                    
                                 .overlay(
                                    Text("Let's get started. Find your MATCH")
                                        .font(.custom("Helvetica-Bold", size: 32))
                                        .bold()
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 5)
                                        .padding(.top, -275)
                                                   )
                                 .edgesIgnoringSafeArea(.top)
                    Spacer()
                                 .edgesIgnoringSafeArea(.bottom)
                                 
                    VStack {
                        // Button to present the upload view controller
                        Button(action: {
                            self.isJobDescriptionUploadPresented = true
                        }) {
                            
                            HStack {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    
                                
                                Text(" Upload Job Description")
                            }
//
                                                        .foregroundColor(.black)
                                                        .fontWeight(.bold)
                                                        .font(.custom("Helvetica-Bold", size: 25))
                                                        .padding()
                                                        .frame(width: 400, height: 100)
                                                        .background(Color(red: 169/225, green: 214/255, blue: 220/255)
                                                        .cornerRadius(40)
//                .shadow(color: .gray, radius: 7, x: 0, y: 5)
                                                                    )
                        
                                                        
                                                }

                    }
                    .offset(y: 350)
//
    
                                }
                    // Navigation links to the upload and resume view controllers
                    .background(Color(red: 218, green: 205, blue: 205).ignoresSafeArea())
                    .sheet(isPresented: $isJobDescriptionUploadPresented) {
                        SwiftUIViewJobDescriptionUploadPopUp()
                    }
                    .sheet(isPresented: $isResumeUploadPresented) {
                        //MARK: Have initializer take array of keywords
                        SwiftUIViewResumeUploadPopup()
                    }
//
                    
                    }
    
                }

            }
            struct ContentView_Previews: PreviewProvider {
                static var previews: some View {
                    ContentView()
                }
            }
        
    

