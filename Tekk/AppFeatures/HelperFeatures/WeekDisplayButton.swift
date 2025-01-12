//
//  WeekDisplayButton.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/10/25.
//

import SwiftUI
import RiveRuntime


struct WeekDisplayButton: View {
    @ObservedObject var mainAppModel: MainAppModel
    
    let text: String
    let interactedDay: Bool
    
    
    var body: some View {
        Button(action: {
            // Add your button action here
        }) {
            ZStack {
                if interactedDay {
                    RiveViewModel(fileName: "Day_High_Score").view()
                        .frame(width: 60, height: 60)
                        .aspectRatio(contentMode: .fit)
                        .clipped()

                    

                    Text(text)
                        .font(.custom("Poppins-Bold", size: 30))
                        .padding(.bottom, 10)
                        .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
                } else {
                    RiveViewModel(fileName: "Day_Null").view()
                        .frame(width: 60, height: 60)
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                    
                    Text(text)
                        .font(.custom("Poppins-Bold", size: 30))
                        .padding(.bottom, 10)
                        .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
                }
            }
        }
    }
}

#Preview {
    let mockAppModel = MainAppModel()
    
    return WeekDisplayButton(
        mainAppModel: mockAppModel,
        text: "34",
        interactedDay: true
    )
}
