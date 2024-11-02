//
//  WelcomeView.swift
//  BravoBall
//
//  Created by Josh on 9/28/24.
//  This file contains the LoginView, which is used to welcome the user.

import SwiftUI
import RiveRuntime

struct WelcomeView: View {
    @StateObject private var globalSettings = GlobalSettings()

    // Note: Binding/ Bool binds this structure, state private func on other pages determines function of this structure
    @Binding var showWelcome: Bool
    @State private var showOnboarding = false
    @State private var showQuestionnaire = false
//    @State private var showQuestionnaire = false
    @State private var textOpacity1: Double = 1.0
    @State private var textOpacity2: Double = 0.0
    // welcomeInput is where bravo is asking for player details, this is what will show when next button on hello bravo page is clicked
    @State private var welcomeInput: Int = 0
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var selectedAge: String = "Select your Age"
    @State private var selectedLevel: String = "Select your Level"
    @State private var selectedPosition: String = "Select your Position"
    // For delayed transitions for questionnaires
    @State private var animationStage = 0
    
    @State private var riveViewOffset: CGSize = .zero // Offset for Rive animation hello
    // var for matchedGeometry function
    @Namespace var questionnaireSpace
    
    
    var body: some View {
        VStack {
            ZStack {
                
                content
                
                // ZStack for matchedGeometry for smooth transitions
                ZStack {
                    // Present WelcomeView when showWelcomeView is true
                    if !showQuestionnaire {
                        FirstQuestionnaireView(showQuestionnaire: $showQuestionnaire)// Pass bindings as needed
                            .matchedGeometryEffect(id: "welcome", in: questionnaireSpace)
                            .offset(x: UIScreen.main.bounds.width) // out of bounds
                    } else {
                        FirstQuestionnaireView(showQuestionnaire: $showQuestionnaire)// Pass bindings as needed
                            .matchedGeometryEffect(id: "welcome", in: questionnaireSpace)
                            .offset(x: 0) // showing
                    }
                }
            }
        }
    }
    
    var content: some View {
        NavigationView {
            // ZStack so lets get tekky button and back button arent confined to VStack
            ZStack {
                VStack {
                    if animationStage >= 3 {
                        WelcomeQuestions(welcomeInput: $welcomeInput, firstName: $firstName, lastName: $lastName, selectedAge: $selectedAge, selectedLevel: $selectedLevel, selectedPosition: $selectedPosition)
                            .transition(.opacity.combined(with: .move(edge: .trailing)))
                            .animation(.easeInOut(duration: 0.3), value: animationStage)
                    }
                }
                Spacer()
                // panting animation
                RiveViewModel(fileName: "test_panting").view()
                    .frame(width: 250, height: 250)
                    .padding(.bottom, 5)
                // riveViewOffset is amount it will offset, button will trigger it
                    .offset(x: riveViewOffset.width, y: riveViewOffset.height)
                    .animation(.easeInOut(duration: 0.5), value: riveViewOffset)
                //MARK: - Bravo messages
                // bravo message 1, confined to ZStack
                Text("Hello there, I'm Bravo! Let's help you become a more tekky player.")
                    .foregroundColor(globalSettings.primaryDarkColor)
                    .padding(.horizontal, 80)
                    .padding(.bottom, 400)
                    .opacity(animationStage == 0 ? 1 : 0)
                    .animation(.easeOut(duration: 0.2), value: animationStage)
                    .font(.custom("Poppins-Bold", size: 16))
                // bravo message 2, confined to ZStack
                Text("Enter your player details below")
                    .foregroundColor(globalSettings.primaryDarkColor)
                    .padding()
                    .padding(.bottom, 500)
                    .padding(.leading, 150)
                    .opacity(animationStage >= 2 ? 1 : 0)
                    .font(.custom("Poppins-Bold", size: 16))
                
                // Back button, confined to ZStack
                HStack {
                    Button(action: {
                        withAnimation {
                            showWelcome = false // Transition to OnboardingView
                        }
                    }) {
                        Image(systemName:"arrow.left")
                            .font(.title2)
                            .foregroundColor(globalSettings.primaryDarkColor)
                            .padding()
                    }
                    .padding(.bottom, 725)
                    
                    Spacer() // moving back button to left
                }
                
                // MARK: - "Next" button
                // Current questionnaire ACTION based on the state variable
                Button(action: {
                    // Progress through animation stage for smooth transitions of Bravo avatar, message, and user input boxe
                    if animationStage < 3 {
                        withAnimation(.spring(duration: 0.4)) {
                            // Move the Rive animation up and to the left
                            riveViewOffset = CGSize(width: -75, height: -250)
                            animationStage = 1
                        }
                        
                        // Delay showing the message
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                textOpacity2 = 1.0
                                animationStage = 2
                            }
                        }
                        
                        // Delay showing the questionnaire
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                welcomeInput = 1
                                animationStage = 3
                            }
                        }
                    } else if validateQ1() {
                        withAnimation {
                            showQuestionnaire = true // Transition to FirstQuestionnaireView
                        }
                    }
                }) {
                    Text("Next")
                        .frame(width: 325, height: 15)
                        .padding()
                        .background(globalSettings.primaryYellowColor)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .font(.custom("Poppins-Bold", size: 16))
                }
                .padding(.top, 700)
            }
            //VStack padding
            .padding()
            .background(.white)
        }
    }
    // MARK: - (change to || for quick nav and && when done)
    // Validation function for Questionnaire 1
    private func validateQ1() -> Bool {
       return !firstName.isEmpty || !lastName.isEmpty || selectedAge != "Select your Age" || selectedLevel != "Select your Level" || selectedPosition != "Select your Position"
    }
}


// MARK: - Preview
struct WelcomeView_Previews: PreviewProvider {
    @State static var showWelcome = true // Example binding variable

    static var previews: some View {
        WelcomeView(showWelcome: $showWelcome)
            .preferredColorScheme(.dark) // Optional: Set the color scheme for the preview
    }
}