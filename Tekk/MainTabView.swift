//
//  MainTabView.swift
//  BravoBall
//
//  Created by Jordan on 1/6/25.
//

import Foundation
import SwiftUI
import RiveRuntime

struct MainTabView: View {
    @ObservedObject var model: OnboardingModel
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var userManager: UserManager
    @StateObject private var homeTab = RiveViewModel(fileName: "Tab_House")
    @StateObject private var progressTab = RiveViewModel(fileName: "Tab_Calendar")
    @StateObject private var savedTab = RiveViewModel(fileName: "Tab_Saved")
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main Content
            ZStack {
                switch appModel.mainTabSelected {
                case 0:
                    testSesGenView(model: model, appModel: appModel)
                case 1:
                    ProgressionView(appModel: appModel)
                case 2:
                    SavedDrillsView()
                case 3:
                    ProfileView(model: model, appModel: appModel, userManager: userManager)
                default:
                    testSesGenView(model: model, appModel: appModel)
                }
            }
            
            // Custom Tab Bar
            HStack(spacing: 0) {
                CustomTabItem(
                    icon: AnyView(homeTab.view()),
                    isSelected: appModel.mainTabSelected == 0
                ) {
                    appModel.mainTabSelected = 0
                }
                
                CustomTabItem(
                    icon: AnyView(progressTab.view()),
                    isSelected: appModel.mainTabSelected == 1
                ) {
                    appModel.mainTabSelected = 1
                }
                
                CustomTabItem(
                    icon: AnyView(savedTab.view()),
                    isSelected: appModel.mainTabSelected == 2
                ) {
                    appModel.mainTabSelected = 2
                }
                
                CustomTabItem(
                    icon: AnyView(homeTab.view()),
                    isSelected: appModel.mainTabSelected == 3
                ) {
                    appModel.mainTabSelected = 3
                }
            }
            .padding()
            .background(Color.white.ignoresSafeArea())
        }
    }
}

struct CustomTabItem: View {
    let icon: AnyView
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                icon
                    .frame(width: 30, height: 30)
                    .scaleEffect(isSelected ? 1.2 : 1.0)
            }
            .frame(maxWidth: .infinity)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
    }
}

#Preview {
    let mockOnboardingModel = OnboardingModel()
    let mockMainAppModel = MainAppModel()
    let mockUserManager = UserManager()
    
    return MainTabView(
        model: mockOnboardingModel,
        appModel: mockMainAppModel,
        userManager: mockUserManager
    )
}
