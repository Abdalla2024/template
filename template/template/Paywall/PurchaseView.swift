// PurchaseView SwiftUI
// Created by Abdalla Abdelmagid on 7/31/2025

// Make cool stuff and share your build with me:

//  --> x.com/adamlyttleapps
//  --> github.com/adamlyttleapps

// Special thanks:

//  --> Mario (https://x.com/marioapps_com) for recommending changes to fix
//      an issue Apple had rejecting the paywall due to excessive use of
//      the word "FREE"

import SwiftUI

struct PurchaseView: View {
    
    @StateObject var purchaseModel: PurchaseModel = PurchaseModel()
    
    @State private var shakeDegrees = 0.0
    @State private var shakeZoom = 0.9
    @State private var showCloseButton = false
    @State private var progress: CGFloat = 0.0

    @Binding var isPresented: Bool
    
    @State var showNoneRestoredAlert: Bool = false

    @State private var freeTrial: Bool = true
    @State private var selectedProductId: String = ""
    
    let color: Color = Color.black
    
    private let allowCloseAfter: CGFloat = 5.0 //time in seconds until close is allows
    
    let hasCooldown: Bool
    
    let placeholderProductDetails: [PurchaseProductDetails] = [
        PurchaseProductDetails(price: "$49.99", productId: "demo_lifetime", duration: "lifetime", durationPlanName: "Lifetime Plan", hasTrial: false),
        PurchaseProductDetails(price: "$4.99", productId: "demo_weekly", duration: "week", durationPlanName: "Weekly Plan", hasTrial: true)
    ]
    
    var callToActionText: String {
        let selectedProduct = purchaseModel.productDetails.first { $0.productId == selectedProductId }
        if let selectedProduct = selectedProduct, selectedProduct.hasTrial {
            return "Start Free Trial"
        } else {
            return "Unlock Now"
        }
    }
    
    var calculateFullPrice: Double? {
        guard let weeklyProduct = purchaseModel.productDetails.first(where: { $0.duration == "week" }) else {
            return nil
        }
        
        let weeklyPriceString = weeklyProduct.price
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        guard let number = formatter.number(from: weeklyPriceString) else {
            return nil
        }
        
        let weeklyPriceDouble = number.doubleValue
        return weeklyPriceDouble * 52
    }
    
    var calculatePercentageSaved: Int {
        guard let fullPrice = calculateFullPrice,
              let lifetimeProduct = purchaseModel.productDetails.first(where: { $0.duration == "lifetime" }) else {
            return 90
        }
        
        let lifetimePriceString = lifetimeProduct.price
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        guard let number = formatter.number(from: lifetimePriceString) else {
            return 90
        }
        
        let lifetimePriceDouble = number.doubleValue
        let saved = Int(100 - ((lifetimePriceDouble / fullPrice) * 100))
        
        return saved > 0 ? saved : 90
    }
    
    var body: some View {
        ZStack (alignment: .top) {
            
            HStack {
                Spacer()
                
                if hasCooldown && !showCloseButton {
                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        .opacity(0.1 + 0.1 * self.progress)
                        .rotationEffect(Angle(degrees: -90))
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
                else {
                    Image(systemName: "multiply")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, alignment: .center)
                        .clipped()
                        .onTapGesture {
                            isPresented = false
                        }
                        .opacity(0.2)
                        .foregroundColor(.black)
                }
            }
            .padding(.top)

            VStack (spacing: 20) {
                
                ZStack {
                    Image("paywallPic")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150, alignment: .center)
                        .scaleEffect(shakeZoom)
                        .rotationEffect(.degrees(shakeDegrees))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                startShaking()
                            }
                        }
                }
                .padding(.top, 30)
                
                VStack (spacing: 10) {
                    Text("Unlock Premium Access")
                        .font(.custom("Geist", size: 30).weight(.semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    VStack (alignment: .leading, spacing: 8) {
                        PurchaseFeatureView(title: "Access full task planning", icon: "calendar", color: color)
                        PurchaseFeatureView(title: "Gain deeper insights", icon: "charts", color: color)
                        PurchaseFeatureView(title: "Personalize your focus", icon: "edit", color: color)
                        PurchaseFeatureView(title: "Remove annoying paywalls", icon: "lock", color: color)
                    }
                    .font(.custom("Geist", size: 19))
                    .padding(.top)
                }
                
                Spacer()
                
                VStack (spacing: 20) {
                    VStack (spacing: 10) {
                        
                        let productDetails = purchaseModel.isFetchingProducts ? placeholderProductDetails : purchaseModel.productDetails
                        
                        ForEach(productDetails) { productDetails in
                            
                            Button(action: {
                                withAnimation {
                                    selectedProductId = productDetails.productId
                                }
                                self.freeTrial = productDetails.hasTrial
                            }) {
                                VStack {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(productDetails.durationPlanName)
                                                .font(.custom("Geist", size: 18).weight(.bold))
                                                .foregroundColor(.black)
                                            if productDetails.hasTrial {
                                                Text("then "+productDetails.price+" per "+productDetails.duration)
                                                    .font(.custom("Geist", size: 14))
                                                    .opacity(0.8)
                                                    .foregroundColor(.black)
                                            }
                                            else {
                                                HStack (spacing: 0) {
                                                    if productDetails.duration == "lifetime" {
                                                        Text("$99.99")
                                                            .strikethrough()
                                                            .opacity(0.4)
                                                            .foregroundColor(.black)
                                                        Text(" " + productDetails.price)
                                                            .foregroundColor(.black)
                                                    } else if let calculateFullPrice = calculateFullPrice,
                                                       let calculateFullPriceLocalCurrency = toLocalCurrencyString(calculateFullPrice),
                                                       calculateFullPrice > 0,
                                                       productDetails.duration != "lifetime"
                                                    {
                                                        //shows the full price based on weekly calculaation
                                                        Text("\(calculateFullPriceLocalCurrency) ")
                                                            .strikethrough()
                                                            .opacity(0.4)
                                                            .foregroundColor(.black)
                                                        Text(" " + productDetails.price)
                                                            .foregroundColor(.black)
                                                    } else {
                                                        Text(" " + productDetails.price)
                                                            .foregroundColor(.black)
                                                    }
                                                }
                                                .opacity(0.8)
                                            }
                                        }
                                        Spacer()
                                        if productDetails.hasTrial {
                                            //removed: Some apps were being rejected with this caption present:
                                            /*Text("FREE")
                                                .font(.title2.bold())*/
                                        }
                                        else {
                                            VStack {
                                                Text("BEST VALUE")
                                                    .font(.custom("Geist", size: 12).weight(.bold))
                                                    .foregroundColor(.white)
                                                    .padding(8)
                                            }
                                            .background(Color.black)
                                            .cornerRadius(6)
                                        }
                                        
                                        ZStack {
                                            Image(systemName: (selectedProductId == productDetails.productId) ? "circle.fill" : "circle")
                                                .foregroundColor((selectedProductId == productDetails.productId) ? color : Color.black.opacity(0.15))
                                            
                                            if selectedProductId == productDetails.productId {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(Color.white)
                                                    .scaleEffect(0.7)
                                            }
                                        }
                                        .font(.title3.bold())
                                        
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                                }
                                //.background(Color(.systemGray4))
                                .cornerRadius(6)
                                .overlay(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke((selectedProductId == productDetails.productId) ? color : Color.black.opacity(0.15), lineWidth: 1) // Border color and width
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill((selectedProductId == productDetails.productId) ? 
                                                LinearGradient(
                                                    colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ) : LinearGradient(
                                                    colors: [Color.black.opacity(0.001)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ))
                                    }
                                )
                            }
                            .accentColor(Color.black)
                            
                        }
                        
                        HStack {
                            Toggle(isOn: $freeTrial) {
                                Text("Free Trial Enabled")
                                    .font(.custom("Geist", size: 18).weight(.bold))
                                    .foregroundColor(.black)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .black))
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .onChange(of: freeTrial) { oldValue, newValue in
                                if !newValue, let firstProductId = self.purchaseModel.productIds.first {
                                    withAnimation {
                                        self.selectedProductId = String(firstProductId)
                                    }
                                }
                                else if newValue, let lastProductId = self.purchaseModel.productIds.last {
                                    withAnimation {
                                        self.selectedProductId = lastProductId
                                    }
                                }
                            }
                        }
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(6)
                        
                    }
                    .opacity(purchaseModel.isFetchingProducts ? 0 : 1)
                    
                    VStack (spacing: 25) {
                        
                        ZStack (alignment: .center) {
                            
                            //if purchasedModel.isPurchasing {
                            ProgressView()
                                .opacity(purchaseModel.isPurchasing ? 1 : 0)
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            
                            Button(action: {
                                //productManager.purchaseProduct()
                                if !purchaseModel.isPurchasing {
                                    purchaseModel.purchaseSubscription(productId: self.selectedProductId)
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    HStack {
                                        Text(callToActionText)
                                        Image(systemName: "chevron.right")
                                    }
                                    Spacer()
                                }
                                .padding()
                                .foregroundColor(.white)
                                .font(.custom("Geist", size: 20).weight(.bold))
                            }
                            .background(color)
                            .cornerRadius(6)
                            .opacity(purchaseModel.isPurchasing ? 0 : 1)
                            .padding(.top)
                            .padding(.bottom, 4)
                            
                            
                        }
                        
                    }
                    .opacity(purchaseModel.isFetchingProducts ? 0 : 1)
                }
                .id("view-\(purchaseModel.isFetchingProducts)")
                .background {
                    if purchaseModel.isFetchingProducts {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    }
                }
                
                VStack (spacing: 5) {
                    
                    /*HStack (spacing: 4) {
                        Image(systemName: "figure.2.and.child.holdinghands")
                            .foregroundColor(Color.red)
                        Text("Family Sharing enabled")
                            .foregroundColor(.white)
                    }
                    .font(.footnote)*/
                    
                    HStack (spacing: 0) {
                        Spacer()
                        
                        Button("Restore Purchases") {
                            purchaseModel.restorePurchases()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                                if !purchaseModel.isSubscribed {
                                    showNoneRestoredAlert = true
                                }
                            }
                        }
                        .alert(isPresented: $showNoneRestoredAlert) {
                            Alert(title: Text("Restore Purchases"), message: Text("No purchases restored"), dismissButton: .default(Text("OK")))
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray), alignment: .bottom
                        )
                        .font(.footnote)
                        .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button("Terms of Use") {
                            if let url = URL(string: "https://abdalla2024.github.io/FokisPomodoroTimer/#/terms") {
                                UIApplication.shared.open(url)
                            }
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray), alignment: .bottom
                        )
                        .font(.footnote)
                        .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button("Privacy Policy") {
                            if let url = URL(string: "https://abdalla2024.github.io/FokisPomodoroTimer/#/privacy") {
                                UIApplication.shared.open(url)
                            }
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray), alignment: .bottom
                        )
                        .font(.footnote)
                        .foregroundColor(.black)
                        
                        Spacer()
                    }
                    //.font(.headline)
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                    
                    
                    
                    
                }

                
            }
        }
        .padding(.horizontal)
        .background(Color.white)
        .onAppear {
            selectedProductId = purchaseModel.productIds.last ?? ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeIn(duration: allowCloseAfter)) {
                    self.progress = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + allowCloseAfter) {
                    withAnimation {
                        showCloseButton = true
                    }
                }
            }
        }
        .onChange(of: purchaseModel.isSubscribed) { oldValue, newValue in
            if(newValue) {
                // Post notification for instant UI updates
                NotificationCenter.default.post(name: .subscriptionStateChanged, object: newValue)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPresented = false
                }
            }
        }
        .onAppear {
            if(purchaseModel.isSubscribed) {
                isPresented = false
            }
        }
        
        
    }
    
    private func startShaking() {
            let totalDuration = 0.7 // Total duration of the shake animation
            let numberOfShakes = 3 // Total number of shakes
            let initialAngle: Double = 10 // Initial rotation angle
            
            withAnimation(.easeInOut(duration: totalDuration / 2)) {
                self.shakeZoom = 0.95
                DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration / 2) {
                    withAnimation(.easeInOut(duration: totalDuration / 2)) {
                        self.shakeZoom = 0.9
                    }
                }
            }

            for i in 0..<numberOfShakes {
                let delay = (totalDuration / Double(numberOfShakes)) * Double(i)
                let angle = initialAngle - (initialAngle / Double(numberOfShakes)) * Double(i)
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(Animation.easeInOut(duration: totalDuration / Double(numberOfShakes * 2))) {
                        self.shakeDegrees = angle
                    }
                    withAnimation(Animation.easeInOut(duration: totalDuration / Double(numberOfShakes * 2)).delay(totalDuration / Double(numberOfShakes * 2))) {
                        self.shakeDegrees = -angle
                    }
                }
            }

            // Stop the shaking and reset to 0
            DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
                withAnimation {
                    self.shakeDegrees = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                    startShaking()
                }
            }
        }
    
    
    struct PurchaseFeatureView: View {
        
        let title: String
        let icon: String
        let color: Color
        
        var body: some View {
            HStack {
                CustomIconView(iconName: icon, color: color)
                    .frame(width: 27, height: 27)
                Text(title)
                    .font(.custom("Geist", size: 16))
                    .foregroundColor(.black)
            }
        }
    }
    
    struct CustomIconView: View {
        let iconName: String
        let color: Color
        
        var body: some View {
            Group {
                switch iconName {
                case "calendar":
                    CalendarIcon()
                case "charts":
                    ChartsIcon()
                case "edit":
                    EditIcon()
                case "lock":
                    LockIcon()
                default:
                    Image(systemName: "questionmark")
                }
            }
            .foregroundColor(color)
        }
    }
    
    struct CalendarIcon: View {
        var body: some View {
            Image("calendar")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    struct ChartsIcon: View {
        var body: some View {
            Image("charts")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    struct EditIcon: View {
        var body: some View {
            Image("edit")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    struct LockIcon: View {
        var body: some View {
            Image("lock")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }

    func toLocalCurrencyString(_ value: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        //formatter.locale = locale
        return formatter.string(from: NSNumber(value: value))
    }

}

extension Notification.Name {
    static let subscriptionStateChanged = Notification.Name("subscriptionStateChanged")
}

#Preview {
    PurchaseView(isPresented: .constant(true), hasCooldown: true)
}
