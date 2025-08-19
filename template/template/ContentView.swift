//
//  ContentView.swift
//  template
//
//  Created by Abdalla Abdelmagid on 8/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showOnboarding = true
    @State private var showPaywall = false
    
    var body: some View {
        ZStack {
            // Background
            Color.white.ignoresSafeArea()
            
            if showOnboarding {
                // Onboarding View
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
                .transition(.opacity)
            } else if showPaywall {
                // Paywall View
                PurchaseView(isPresented: $showPaywall, hasCooldown: false)
                    .transition(.opacity)
            } else {
                // Main App Content (placeholder)
                VStack(spacing: 20) {
                    Image(systemName: "star.fill")
                        .imageScale(.large)
                        .foregroundStyle(.yellow)
                        .font(.system(size: 60))
                    
                    Text("Welcome to Your App!")
                        .font(.title)
                        .foregroundColor(.black)
                    
                    Text("This is where your main app content would go")
                        .foregroundColor(.black.opacity(0.7))
                        .multilineTextAlignment(.center)
                    
                    VStack(spacing: 15) {
                        Button("Show Onboarding Again") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showOnboarding = true
                                showPaywall = false
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Show Paywall") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showOnboarding = false
                                showPaywall = true
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                    }
                }
                .padding()
                .transition(.opacity)
            }
        }
        .onAppear {
            // Auto-advance to main content after onboarding
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if showOnboarding {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showOnboarding = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
