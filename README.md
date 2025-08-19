# iOS App Template - Paywall & Onboarding

A reusable template for iOS apps that includes a professional paywall and onboarding system. This template is designed to save you time by providing pre-built, customizable components that you can easily integrate into your apps.

## 🚀 Features

### Paywall System

- **Professional Design**: Clean, modern UI with smooth animations
- **StoreKit Integration**: Ready-to-use in-app purchase functionality
- **Flexible Pricing**: Support for multiple subscription tiers (weekly, lifetime)
- **Free Trial Support**: Built-in free trial functionality
- **Restore Purchases**: Automatic purchase restoration
- **Apple Compliance**: Follows Apple's guidelines (avoiding excessive "FREE" text)
- **Customizable**: Easy to modify colors, text, and features

### Onboarding System

- **Smooth Transitions**: Beautiful page transitions and animations
- **Customizable Content**: Easy to modify text, images, and layout
- **Progress Indicators**: Visual progress tracking
- **Skip Functionality**: Optional skip button for returning users


## 🛠️ Installation

1. **Clone or Download**: Get the template files
2. **Open in Xcode**: Open the `.xcodeproj` file
3. **Build**: Ensure the project builds successfully
4. **Customize**: Modify the content and styling as needed

## 🔧 Customization Guide

### Paywall Customization

#### 1. Product Configuration

Edit `PurchaseModel.swift` to configure your products:

```swift
// Update these product IDs with your actual StoreKit product IDs
self.productIds = ["your_lifetime_id", "your_weekly_id"]

// Update product details
self.productDetails = [
    PurchaseProductDetails(
        price: "Loading...",
        productId: "your_lifetime_id",
        duration: "lifetime",
        durationPlanName: "Lifetime Plan",
        hasTrial: false
    ),
    PurchaseProductDetails(
        price: "Loading...",
        productId: "your_weekly_id",
        duration: "week",
        durationPlanName: "7-Day Trial",
        hasTrial: true
    )
]
```

#### 2. UI Customization

Modify `PurchaseView.swift` to customize:

- **Colors**: Change the `color` property
- **Text**: Update titles, descriptions, and button text
- **Features**: Modify the feature list in the `PurchaseFeatureView`
- **Images**: Replace `paywallPic` with your app's image

#### 3. Feature List

Update the features shown to users:

```swift
VStack (alignment: .leading, spacing: 8) {
    PurchaseFeatureView(title: "Your feature 1", icon: "calendar", color: color)
    PurchaseFeatureView(title: "Your feature 2", icon: "charts", color: color)
    PurchaseFeatureView(title: "Your feature 3", icon: "edit", color: color)
    PurchaseFeatureView(title: "Your feature 4", icon: "lock", color: color)
}
```

#### 4. Terms & Privacy URLs

Update the URLs in the action sheet:

```swift
if let url = URL(string: "https://yourapp.com/terms") {
    UIApplication.shared.open(url)
}
```

### Onboarding Customization

#### 1. Content Updates

Edit `OnboardingView.swift` to customize:

- **Page Content**: Update text, images, and descriptions
- **Navigation**: Modify the flow and number of pages
- **Styling**: Change colors, fonts, and layout

#### 2. App-Specific Content

Replace the placeholder content with your app's information:

```swift
// Update these with your app's content
Text("Welcome to Your App")
    .font(.largeTitle)
    .fontWeight(.bold)

Text("Your app's description goes here")
    .font(.body)
    .multilineTextAlignment(.center)
```

## 🔐 StoreKit Setup

1. **App Store Connect**: Create your in-app purchase products
2. **Product IDs**: Update the `productIds` array in `PurchaseModel.swift`
3. **Testing**: Use sandbox accounts for testing purchases
4. **Production**: Ensure your app is properly configured for production

## 📋 Integration Steps

### 1. Add to Your App

```swift
import SwiftUI

struct ContentView: View {
    @State private var showPaywall = false
    @State private var showOnboarding = false

    var body: some View {
        VStack {
            Button("Show Paywall") {
                showPaywall = true
            }

            Button("Show Onboarding") {
                showOnboarding = true
            }
        }
        .sheet(isPresented: $showPaywall) {
            PurchaseView(isPresented: $showPaywall, hasCooldown: true)
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView()
        }
    }
}
```

### 2. Handle Purchase State

```swift
// Listen for subscription changes
.onReceive(NotificationCenter.default.publisher(for: .subscriptionStateChanged)) { notification in
    if let isSubscribed = notification.object as? Bool {
        // Handle subscription state change
        if isSubscribed {
            // User has active subscription
        } else {
            // User has no active subscription
        }
    }
}
```

### 3. Check Subscription Status

```swift
@StateObject private var purchaseModel = PurchaseModel()

// Check if user is subscribed
if purchaseModel.isSubscribed {
    // Show premium content
} else {
    // Show paywall or limited content
}
```

## 🎨 Design Customization

### Colors

The template uses a clean black and white design. To customize:

```swift
// In PurchaseView.swift
let color: Color = Color.blue // Change to your brand color

// Update accent colors throughout the UI
.foregroundColor(.blue) // Replace with your color
.background(Color.blue) // Replace with your color
```

### Fonts

The template uses the "Geist" font family. To change:

```swift
// Replace all instances of .custom("Geist", size: X)
.font(.system(size: 18, weight: .bold)) // Use system font
// or
.font(.custom("YourFont", size: 18)) // Use custom font
```

### Images

Replace the placeholder images:

1. **Paywall Image**: Replace `paywallPic` in the Paywall Assets
2. **Feature Icons**: Update the custom icon views (calendar, charts, edit, lock)
3. **Onboarding Images**: Add your app's screenshots or illustrations

## 🚨 Important Notes

### Apple Guidelines Compliance

- The template avoids excessive use of the word "FREE" to comply with Apple's guidelines
- Uses proper StoreKit 2 implementation
- Follows iOS design patterns and accessibility guidelines

### Testing

- Always test with sandbox accounts before production
- Verify purchase restoration works correctly
- Test on different device sizes and orientations

### Production Deployment

- Ensure your app's bundle identifier matches App Store Connect
- Verify in-app purchase products are properly configured
- Test the complete purchase flow in production
