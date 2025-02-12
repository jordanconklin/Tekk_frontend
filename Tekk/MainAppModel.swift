import Foundation
import UIKit

class MainAppModel: ObservableObject {
    let globalSettings = GlobalSettings()
    
    @Published var mainTabSelected = 0
    @Published var currentProgress = 0
    @Published var addCheckMark = false
    @Published var streakIncrease: Int = 0
    @Published var interactedDay = false
    @Published var currentWeek = 0
    @Published var completedWeeks: [WeekData] = [WeekData()]
    
    @Published var showAlert = false
    @Published var alertType: AlertType = .none
    
    struct WeekData {
        var weekNumber: Int = 1
        var progress: Int = 0
        var isCompleted: Bool = false
    }
    
    func getProgressForCurrentWeek() -> Int {
        guard currentWeek < completedWeeks.count else { return 0 }
        return completedWeeks[currentWeek].progress
    }
    
    func completeDay() {
        guard currentWeek < completedWeeks.count else { return }
        
        if completedWeeks[currentWeek].progress >= 6 {
            let newWeek = WeekData(weekNumber: completedWeeks.count + 1)
            completedWeeks.append(newWeek)
            completedWeeks[currentWeek].isCompleted = true
            currentWeek += 1
            currentProgress = 0
        } else {
            completedWeeks[currentWeek].progress += 1
            currentProgress = completedWeeks[currentWeek].progress
        }
    }
    
    enum AlertType {
        case logout
        case delete
        case none
    }
    
    // Navigation bar configuration
    func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(globalSettings.primaryYellowColor)
        
        // Apply the appearance settings
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
} 