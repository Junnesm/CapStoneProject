//
//  ContentView.swift
//  CapStoneProject
//
//  Created by Junne Murdock on 3/6/23.
//RESUMATE


import SwiftUI

    struct ContentView: View {
    
        @State private var isJobDescriptionUploadPresented = false
        @State private var isResumeUploadPresented = false
    
        var body: some View {
            NavigationView {
    
                VStack{
                    Image("Untitled design")
                                 .resizable()
                                 .aspectRatio(contentMode: .fill)
                                 .frame(height: 200)
                                 .overlay(
                                    Text("Welcome! Let's find your opportunities")
                                        .font(.title)
                                    //  .font(Font.custom("Antic", size: 24))
                                        .bold()
                                        .foregroundColor(.black)
                                                   )
                                 .edgesIgnoringSafeArea(.top)
                    HStack {
                        // Button to present the upload view controller
                        Button(action: {
                            self.isJobDescriptionUploadPresented = true
                        }) {
                            Image("JobDescriptionUploadButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 500, height: 400)
                                .shadow(color: .gray, radius: 4, x: 0, y: 2)
                        }
                        
                       
    
    
                        // Button with image to present another view controller
    //                    Button(action: {
    //                        self.isResumeUploadPresented = true
    //                    }) {
    //                        Image("ResumeUploadButton")
    //                            .resizable()
    //                            .aspectRatio(contentMode: .fit)
    //                    }
                    }
                    .offset(y: -230)
                    List {
                                        Text("Job Ad 1")
                                        Text("Ziprecruiter")
                                        Text("Your Mom")
                                    }
    
                                }
                    // Navigation links to the upload and resume view controllers
                    .background(Color(red: 218, green: 205, blue: 205).ignoresSafeArea())
                    .sheet(isPresented: $isJobDescriptionUploadPresented) {
                        SwiftUIViewJobDescriptionUploadPopUp()
                    }
                    .sheet(isPresented: $isResumeUploadPresented) {
                        SwiftUIViewResumeUploadPopup()
                    }
    
                }
            }
            struct ContentView_Previews: PreviewProvider {
                static var previews: some View {
                    ContentView()
                }
            }
        }
    

