import Foundation
import Glassfy
import SwiftUI

class SubscriptionManager: ObservableObject, Loggable {
    private let apiKey = "2531f51e758b47e2b129e255080a82ce"
    
    private let nceOfferings = "nce_offerings"
    private let ncePermissions = "nce_permissions"
    
    private let introductoryOfferings = "introductory_offerings"
    //private let ncePermissions = "nce_permissions"
    
    private let productIdMonthly = "com.eztestprep.ncequizapp.monthly"
    private let productIdHalfYearly = "com.eztestprep.ncequizapp.halfyearly"
    
    private let productIdIntroductoryMonthly = "com.eztestprep.ncequizapp.monthly.introductory"
    
    private let productIdIntroductoryHalfYearly = "com.eztestprep.ncequizapp.halfyearly.introductory"
    
    private var monthlySku: Glassfy.Sku? {
        didSet {
            log(
                "Fetched subscription SKU with id: \(monthlySku?.productId ?? "n/a")"
            )
        }
    }
    
    private var monthlyIntroductorySku: Glassfy.Sku? {
        didSet {
            log(
                "Fetched subscription SKU with id: \(monthlyIntroductorySku?.productId ?? "n/a")"
            )
        }
    }
    
    private var halfYearlySku: Glassfy.Sku? {
        didSet {
            log(
                "Fetched subscription SKU with id: \(halfYearlySku?.productId ?? "n/a")"
            )
        }
    }
    
    private var halfYearlyIntroductorySku: Glassfy.Sku? {
        didSet {
            log(
                "Fetched subscription SKU with id: \(halfYearlyIntroductorySku?.productId ?? "n/a")"
            )
        }
    }

    private static var _shared: SubscriptionManager?

    public static var shared: SubscriptionManager {
        guard let _shared = _shared else {
            fatalError(
                "Whoops, seems like you forgot to initialize SubscriptionManager. Please call SubscriptionManager.initialize() before using."
            )
        }
        return _shared
    }
    
    public var isEligibleForPMonthlyIntroductoryOffer: Bool {
        [.eligible, .unknown].contains(monthlySku?.introductoryEligibility)
    }
    
    public var isEligibleForHalfYearlyIntroductoryOffer: Bool {
        [.eligible, .unknown].contains(halfYearlySku?.introductoryEligibility)
    }

    @Published
    var isSubscribed: Bool = false
    
    @Published
    var hasNeverSubscribed: Bool = false
    
    @State private var shouldAnimate = false

    @Published
    var result: SubscriptionResult?

    private let userDefaults = UserDefaults.standard

    private init() {
        Glassfy.initialize(apiKey: apiKey, watcherMode: false)
        Task {
            await fetchProduct()
            await checkPermission()
        }
    }

    public static func initialize() {
        _shared = SubscriptionManager()
    }

    // MARK: - Private functions

    private func fetchProduct() async {
        do {
            let offerings = try await Glassfy.offerings()
            
            if let _nceOfferings = offerings[nceOfferings] {
                for sku in _nceOfferings.skus {
                    if (sku.productId == productIdMonthly) {
                        monthlySku = sku
                    } else if(sku.productId == productIdHalfYearly) {
                        halfYearlySku = sku
                    }
                }
            }
            
            if let _introductoryOfferings = offerings[introductoryOfferings] {
                for sku in _introductoryOfferings.skus {
                    if (sku.productId == productIdIntroductoryMonthly) {
                        monthlyIntroductorySku = sku
                    } else if(sku.productId == productIdIntroductoryHalfYearly) {
                        halfYearlyIntroductorySku = sku
                    }
                }
            }

        } catch {
            log(error)
        }
    }

    private func checkPermission() async {
        do {
            let permissions = try await Glassfy.permissions()
            let subscriberId = permissions.subscriberId ?? ""
            await StorageManager.shared.saveSubscriberId(subscriberId)
            if let permission = permissions[ncePermissions] {
                checkHasPurchases(permission)
                verifyPermission(permission)
            }
            
        } catch {
            log(error)
        }
    }

    private func verifyPermission(_ permission: Glassfy.Permission) {
        log(
            "Permission verified and it is \(permission.isValid ? "valid ✅" : "invalid ⛔️")"
        )
        DispatchQueue.main.async {
            self.isSubscribed = permission.isValid
        }
    }
    
    private func checkHasPurchases(_ permission: Glassfy.Permission) {
        log(
            "Has purchased earlier \((permission.entitlement.rawValue == -9) ? "no ⛔️" : "yes ✅")"
        )
        DispatchQueue.main.async {
            self.hasNeverSubscribed = (permission.entitlement.rawValue == -9)
        }
    }
    
    private var isEligibleForIntroductoryOffer: Bool {
        [.eligible, .unknown].contains(monthlyIntroductorySku?.introductoryEligibility)
        && [.eligible, .unknown].contains(halfYearlyIntroductorySku?.introductoryEligibility)
    }

    // MARK: - Public functions
    func getLocalizedDurationForMonthlySubscription() -> String {
        return "month"
    }
    
    func getLocalizedDurationForHalfYearlySubscription() -> String {
        return "6 months"
    }
    
    func monthlyPrice() -> String {
        if monthlySku != nil {
            return "\(monthlySku!.product.localizedPrice) / month"
        }
        return "$24.99 / month"
    }
    
    func monthlyPriceWithoutMonthSuffix() -> String {
        if monthlySku != nil {
            return "\(monthlySku!.product.localizedPrice)"
        }
        return "$24.99"
    }
    
    func monthlyIntroductoryPrice() -> String {
        if monthlyIntroductorySku != nil {
            return "\(monthlyIntroductorySku!.product.localizedPrice) / month"
        }
        return "$12.49 / month"
    }
    
    func monthlyIntroductoryPriceWithoutMonthSuffix() -> String {
        if monthlyIntroductorySku != nil {
            return monthlyIntroductorySku!.product.introductoryPrice?.localizedPrice ?? "$12.49"
        }
        return "$12.49"
    }
    
    func halfYearlyPrice() -> String {
        if halfYearlySku != nil {
            return "\(halfYearlySku!.product.localizedPrice) / 6 months"
        }
        return "$64.99 / 6 months"
    }
    
    func halfYearlyPriceWithoutMonthSuffix() -> String {
        if halfYearlySku != nil {
            return "\(halfYearlySku!.product.localizedPrice)"
        }
        return "$64.99"
    }
    
    func halfYearlyIntroductoryPrice() -> String {
        if halfYearlyIntroductorySku != nil {
            return "\(halfYearlyIntroductorySku!.product.localizedPrice) / 6 months"
        }
        return "$32.49 / 6 months"
    }
    
    func halfYearlyIntroductoryPriceWithoutMonthSuffix() -> String {
        if halfYearlyIntroductorySku != nil {
            return halfYearlyIntroductorySku!.product.introductoryPrice?.localizedPrice ?? "$32.49"
        }
        return "$32.49"
    }
    
    func halfYearlyPriceAsMonthly() -> String {
        if let halfYearlyPrice = halfYearlySku?.product.price {
            let perMonthPrice: Double = Double.init(halfYearlyPrice) / 6
            
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            currencyFormatter.roundingMode = .halfUp

            if let formattedPrice = currencyFormatter.string(from: perMonthPrice as NSNumber) {
                if let priceInFloat = Float.init(formattedPrice) {
                    return "Less than \(priceInFloat.rounded(.awayFromZero)) a month"
                } else {
                    return "Less than $11 a month"
                }
            } else {
                return "Less than $11 a month"
            }
        } else {
            return "Less than $11 a month"
        }
    }
    
    func getHalfYearlyPriceAsMontlyForIntroductoryOffer() -> String {
        return "Less than $6 a month"
    }
    
    public func getSavings() -> String {
        return "Save $85"
    }
    
    public func getSavingsForIntroductoryPrice() -> String {
        return "Save $117"
    }
    
    public func purchaseMonthlySubscription() async -> SubscriptionResult? {
        do {
            log("Purchasing subscription..")
            guard let monthlySku = monthlySku else {
                return .error(
                    message: "Product cannot be fetched.\nPlease check your internet connection and try again."
                )
            }
            let transaction = try await Glassfy.purchase(sku: monthlySku)
            let subscriberId = transaction.permissions.subscriberId ?? ""
            await StorageManager.shared.saveSubscriberId(subscriberId)
            if let permission = transaction.permissions[ncePermissions] {
                checkHasPurchases(permission)
                verifyPermission(permission)
                if permission.isValid {
                    return .success
                }
            }

            return .error(
                message: "Permission cannot be granted.\nPlease try again later."
            )
        } catch {
            if let error = error as? SKError {
                switch error.code {
                case .paymentCancelled:
                    log("Payment cancelled 💸")
                    return nil
                default:
                    print("")
                    log(error)
                }
            }
            return .error(
                message: "Something went wrong while subscribing.\nPlease try again later."
            )
        }
    }
    
    public func purchaseHalfYearlySubscription() async -> SubscriptionResult? {
        do {
            log("Purchasing subscription..")
            guard let halfYearlySku = halfYearlySku else {
                return .error(
                    message: "Product cannot be fetched.\nPlease check your internet connection and try again."
                )
            }
            let transaction = try await Glassfy.purchase(sku: halfYearlySku)
            let subscriberId = transaction.permissions.subscriberId ?? ""
            await StorageManager.shared.saveSubscriberId(subscriberId)
            if let permission = transaction.permissions[ncePermissions] {
                checkHasPurchases(permission)
                verifyPermission(permission)
                if permission.isValid {
                    return .success
                }
            }
            return .error(
                message: "Permission cannot be granted.\nPlease try again later."
            )
        } catch {
            if let error = error as? SKError {
                switch error.code {
                case .paymentCancelled:
                    log("Payment cancelled 💸")
                    return nil
                default:
                    print("")
                    log(error)
                }
            }
            return .error(
                message: "Something went wrong while subscribing.\nPlease try again later."
            )
        }
    }
    
    // ===========
    public func purchaseMonthlyIntroductorySubscription() async -> SubscriptionResult? {
        do {
            log("Purchasing subscription..")
            guard let monthlyIntroductorySku = monthlyIntroductorySku else {
                return .error(
                    message: "Product cannot be fetched.\nPlease check your internet connection and try again."
                )
            }
            let transaction = try await Glassfy.purchase(sku: monthlyIntroductorySku)
            let subscriberId = transaction.permissions.subscriberId ?? ""
            await StorageManager.shared.saveSubscriberId(subscriberId)
            if let permission = transaction.permissions[ncePermissions] {
                checkHasPurchases(permission)
                verifyPermission(permission)
                if permission.isValid {
                    return .success
                }
            }

            return .error(
                message: "Permission cannot be granted.\nPlease try again later."
            )
        } catch {
            if let error = error as? SKError {
                switch error.code {
                case .paymentCancelled:
                    log("Payment cancelled 💸")
                    return nil
                default:
                    print("")
                    log(error)
                }
            }
            return .error(
                message: "Something went wrong while subscribing.\nPlease try again later."
            )
        }
    }
    
    public func purchaseHalfYearlyIntroductorySubscription() async -> SubscriptionResult? {
        do {
            log("Purchasing subscription..")
            guard let halfYearlyIntroductorySku = halfYearlyIntroductorySku else {
                return .error(
                    message: "Product cannot be fetched.\nPlease check your internet connection and try again."
                )
            }
            let transaction = try await Glassfy.purchase(sku: halfYearlyIntroductorySku)
            let subscriberId = transaction.permissions.subscriberId ?? ""
            await StorageManager.shared.saveSubscriberId(subscriberId)
            if let permission = transaction.permissions[ncePermissions] {
                checkHasPurchases(permission)
                verifyPermission(permission)
                if permission.isValid {
                    return .success
                }
            }
            return .error(
                message: "Permission cannot be granted.\nPlease try again later."
            )
        } catch {
            if let error = error as? SKError {
                switch error.code {
                case .paymentCancelled:
                    log("Payment cancelled 💸")
                    return nil
                default:
                    print("")
                    log(error)
                }
            }
            return .error(
                message: "Something went wrong while subscribing.\nPlease try again later."
            )
        }
    }
    // ===========

    public func restorePurchase() async {
        do {
            log("Restoring purchase...")
            let permissions = try await Glassfy.restorePurchases()
            let subscriberId = permissions.subscriberId ?? ""
            await StorageManager.shared.saveSubscriberId(subscriberId)
            if let permission = permissions[ncePermissions] {
                checkHasPurchases(permission)
                verifyPermission(permission)
            }
        } catch {
            log(error)
        }
    }
}

// MARK: - SubscriptionResult

extension SubscriptionManager {
    enum SubscriptionResult {
        case success, error(message: String)

        var title: String {
            switch self {
            case .success:
                return "Congratulations! 🥳"
            case .error:
                return "Whoops 😩"
            }
        }

        var message: String {
            switch self {
            case .success:
                return "You successfully subscribed to premium features!"
            case let .error(message):
                return message
            }
        }
    }
}

struct SubscriptionManager_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}

// MARK: - Localized price

extension SKProduct {
    fileprivate var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
    
    var localizedSubscriptionPeriod: String {
            let dateComponents: DateComponents
            
        switch subscriptionPeriod?.unit {
            case .day:
            dateComponents = DateComponents(day: subscriptionPeriod?.numberOfUnits)
            case .week:
            dateComponents = DateComponents(weekOfMonth: subscriptionPeriod?.numberOfUnits)
            case .month:
            dateComponents = DateComponents(month: subscriptionPeriod?.numberOfUnits)
            case .year:
            dateComponents = DateComponents(year: subscriptionPeriod?.numberOfUnits)
            @unknown default:
                fatalError()
            }
            
            return DateComponentsFormatter.localizedString(from: dateComponents, unitsStyle: .full) ?? ""
        }
}

extension SKProductDiscount {
    fileprivate var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
    
    var localizedSubscriptionPeriod: String {
            let dateComponents: DateComponents
            
        switch subscriptionPeriod.unit {
            case .day:
            dateComponents = DateComponents(day: subscriptionPeriod.numberOfUnits)
            case .week:
            dateComponents = DateComponents(weekOfMonth: subscriptionPeriod.numberOfUnits)
            case .month:
            dateComponents = DateComponents(month: subscriptionPeriod.numberOfUnits)
            case .year:
            dateComponents = DateComponents(year: subscriptionPeriod.numberOfUnits)
            @unknown default:
                fatalError()
            }
            
            return DateComponentsFormatter.localizedString(from: dateComponents, unitsStyle: .full) ?? ""
        }
}
