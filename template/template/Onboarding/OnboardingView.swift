//
//  OnboardingView.swift
//
//  Created by Adam Abdalla Abdelmagid on 7/31/2025.
//
//  adamlyttleapps.com
//  twitter.com/adamlyttleapps.com
//
//  Usage:
/*
OnboardingView(appName: "Real Estate Calculator", features: [
    Feature(title: "Mortgage Repayments", description: "Easily calculate weekly, monthly and yearly repayments ", icon: "house"),
    Feature(title: "Amortization", description: "Quickly view amortization for the life of the loan", icon: "chart.line.downtrend.xyaxis"),
    Feature(title: "Deposit Calculator", description: "Calculate deposit based on purchase price and savings", icon: "percent"),
    Feature(title: "Ad-Free Experience", description: "Thank you for downloading my app, I hope you enjoy it :-)", icon: "party.popper"),
], color: Color.blue)
*/

import SwiftUI

struct Feature: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String?
}

struct OnboardingView: View {
    @State var appName: String
    let features: [Feature]
    let color: Color?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            // App Icon Placeholder - Add your app icon here
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "app.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                )
                .padding(.top, 60)
                .padding(.bottom, 40)
            
            // Welcome Text
            VStack(spacing: 8) {
                Text("Welcome to")
                    .font(.title2)
                    .foregroundColor(.black.opacity(0.8))
                    .fontWeight(.medium)
                
                Text(appName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            .padding(.bottom, 50)
            
            Spacer()
            
            // Features List
            VStack {
                ForEach(features) { feature in
                    VStack(alignment: .leading) {
                        HStack(alignment: .top, spacing: 0) {
                            if let icon = feature.icon {
                                Image(systemName: icon)
                                    .font(.system(size: 30))
                                    .frame(width: 45, height: 45, alignment: .center)
                                    .foregroundColor(color ?? Color.blue)
                                    .padding(.trailing, 15)
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text(feature.title)
                                    .fontWeight(.bold)
                                    .font(.system(size: 16))
                                Text(feature.description)
                                    .font(.system(size: 15))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineLimit(nil)
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal,20)
                    .padding(.bottom, 20)
                }
            }
            .padding(.bottom, 30)
            
            Spacer()
            
            // Get Started Button
            VStack {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 8) {
                        Text("Get Started")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(color ?? Color.blue)
                    )
                }
            }
            .padding(.top, 15)
            .padding(.bottom, 50)
            .padding(.horizontal,15)
        }
        .padding()
    }
}

#Preview {
    OnboardingView(
        appName: "Template App",
        features: [
            Feature(title: "Professional Paywall", description: "Ready-to-use in-app purchase system with StoreKit integration", icon: "creditcard"),
            Feature(title: "Beautiful Onboarding", description: "Customizable welcome experience for your users", icon: "hand.wave"),
            Feature(title: "Easy Customization", description: "Simple template structure for quick app development", icon: "paintbrush"),
            Feature(title: "Production Ready", description: "Built following Apple's guidelines and best practices", icon: "checkmark.shield")
        ],
        color: .blue
    )
}
