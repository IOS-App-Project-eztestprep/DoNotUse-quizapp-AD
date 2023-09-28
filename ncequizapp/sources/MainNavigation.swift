import SwiftUI

struct MainNavigation: View {
    @StateObject
    var questionDatasource = QuizManager()
    
    @StateObject
    var storageManager = StorageManager.shared
    
    @StateObject
    var userSettings = StorageManager.shared.userSettings
    
    @StateObject
    var subscriptionManager = SubscriptionManager.shared
    
    @State
    var selectedIndex: Int = 0
    
    @EnvironmentObject
    private var delegate: AppDelegate

    var body: some View {
        if !userSettings.isCompleted {
            GetStartedView()
                .environmentObject(storageManager)
                .environmentObject(subscriptionManager)
        } else {
            CustomTabView(
                tabs: TabType.allCases.map { $0.tabItem },
                selectedIndex: $selectedIndex
            ) { index in
                let type = TabType(rawValue: index) ?? .home
                getTabView(type: type)
                    .environmentObject(questionDatasource)
                    .environmentObject(storageManager)
                    .environmentObject(subscriptionManager)
            }
            .fullScreenCover(isPresented: .constant(delegate.openedFromNotification || delegate.showBadgeNotification),onDismiss: {
                print("Dismiss")
                delegate.showBadgeNotification = false
                
//                delegate.badgesToShow.removeFirst()
//                if delegate.badgesToShow.count > 0 {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        delegate.showBadgeNotification = true
//                    }
//                }
                
            }, content: {
                if(delegate.openedFromNotification) {
                    IntroductoryOfferView().environmentObject(subscriptionManager)
                } else if(delegate.showBadgeNotification) {
                    let badgeToShow = delegate.badgesToShow.first
                    if(badgeToShow != nil && badgeToShow != BadgeNumber.badge42) {
                        BadgeNotificationView(showingSheet: $delegate.showBadgeNotification, badgeNumber: badgeToShow!, tabSelection: .constant(1))
                    }
                }
            })
        }
    }

    @ViewBuilder
    func getTabView(type: TabType) -> some View {
        switch type {
        case .home:
            HomeView(
                tabSelection: $selectedIndex,
                cardState: UIStateModel(activeCard: 0, screenDrag: 0.0),
                categoryCardState: UIStateModel(activeCard: 0, screenDrag: 0.0)
            )
        case .stats:
            StatsView(tabSelection: $selectedIndex)
        case .quiz:
            QuizListView(tabSelection: $selectedIndex)
        case .settings:
            SettingsView(tabSelection: $selectedIndex)
        }
    }
}

struct MainNavigation_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigation()
    }
}

struct TabItemData {
    let image: String
}
