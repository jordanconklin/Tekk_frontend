//
//  OnboardingModelTest.swift
//  BravoBall
//
//  Created by Jordan on 1/6/25.
//

import Foundation

class OnboardingModel: ObservableObject {
    let globalSettings = GlobalSettings()
    

    @Published var currentStep = 0
    // For question transition when back button pressed
    @Published var backTransition: Bool = false
    @Published var onboardingData = OnboardingData()
    
    @Published var showLoginPage = false
    @Published var showWelcome = false
    @Published var showIntroAnimation = false
    @Published var isLoggedIn = false
    @Published var authToken = ""
    @Published var isPasswordVisible: Bool = false
    @Published var numberOfOnboardingPages = 11
    
    

    
    // Variables for when onboarding data is being submitted
    @Published var isLoading = true
    @Published var errorMessage: String = ""
    
    
    
    // Animation scale for intro animation
    @Published var animationScale: CGFloat = 1.5
    
    struct OnboardingData: Codable {
        var ageRange: String = ""
        var level: String = ""
        var position: String = ""
        var playstyleRepresentatives: [String] = []
        var strengths: [String] = []
        var weaknesses: [String] = []
        var hasTeam: Bool = false
        var primaryGoal: String = ""
        var timeline: String = ""
        var skillLevel: String = ""
        var trainingDays: [String] = []
        var availableEquipment: [String] = []
        var firstName: String = ""
        var lastName: String = ""
        var email: String = ""
        var password: String = ""
    }
    
    let ageRanges = ["Youth (Under 12)", "Teen (13-16)", "Junior (17-19)", "Adult (20-29)", "Senior (30+)"]
    let levels = ["Beginner", "Intermediate", "Competitive", "Professional"]
    let positions = ["Goalkeeper", "Fullback", "Centerback", "Defensive Mid", "Central Mid", "Attacking Mid"]
    let players = ["Alan Virgilus", "Harry Maguire", "Big Sean", "Big Adam", "Big Bob", "Oscar Bobb"]
    let skills = ["Passing", "Dribbling", "Shooting", "First Touch", "Crossing", "1v1 Defending"]
    let goals = [
        "I want to improve my overall skill level",
        "I want to be the best player on my team",
        "I want to get scouted for college",
        "I want to become a professional soccer player"
    ]
    let timelines = ["Within 3 months", "Within 6 months", "Within 1 year", "Long term goal (2+ years)"]
    let trainingIntensities = [
        "Light (2-3 sessions/week)",
        "Moderate (3-4 sessions/week)",
        "Intense (4-5 sessions/week)",
        "Professional (6+ sessions/week)"
    ]
    let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    let equipment = ["Ball", "Cones", "Goals", "Agility Ladder", "Resistance Bands", "Training Dummy"]
    

    // Checks if youre allowed to move to next question (validates data)
    func canMoveNext() -> Bool {
        switch currentStep {
        case 0: return !onboardingData.ageRange.isEmpty
        case 1: return !onboardingData.level.isEmpty
        case 2: return !onboardingData.position.isEmpty
        case 3: return !onboardingData.playstyleRepresentatives.isEmpty
        case 4: return !onboardingData.strengths.isEmpty && !onboardingData.weaknesses.isEmpty
        case 5: return true // hasTeam is always valid as it's a boolean
        case 6: return !onboardingData.primaryGoal.isEmpty
        case 7: return !onboardingData.timeline.isEmpty
        case 8: return !onboardingData.trainingDays.isEmpty
        case 9: return !onboardingData.availableEquipment.isEmpty
        case 10: return !onboardingData.firstName.isEmpty &&
                        !onboardingData.lastName.isEmpty &&
                        !onboardingData.email.isEmpty &&
                        !onboardingData.password.isEmpty
        default: return false
        }
    }
    
    //MARK: Global functions
    
    // Attempts to the next question
    func moveNext() {
        if canMoveNext() && currentStep < numberOfOnboardingPages {
            currentStep += 1
        }
    }
    
    // Attempts to skip to the next question
    func skipToNext() {
        if currentStep < numberOfOnboardingPages {
            currentStep += 1
        }
    }
    
    // Attempts to move back through back button
    func movePrevious() {
        if currentStep > 0 {
            currentStep -= 1
        } else if currentStep == 0 {
            // Return to welcome screen
            showWelcome = false
        }
    }
    
    func resetOnboardingData() {
        // Reset all published properties for onboarding
        currentStep = 0
        showLoginPage = false
        showWelcome = false
        showIntroAnimation = false // TODO: test this when user resets app
        authToken = ""
        
        // Reset onboardingData to default values
        onboardingData = OnboardingData()  // This creates a new instance with default values
        
        // Debug print
        print("OnboardingModel reset completed")
        print("first name: \(onboardingData.firstName)")
        print("last name: \(onboardingData.lastName)")
        print("email: \(onboardingData.email)")
        print("password: \(onboardingData.password)")
        print("Current step: \(currentStep)")
        print("auth token: \(authToken)")
    }
}