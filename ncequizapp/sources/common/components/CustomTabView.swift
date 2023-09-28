import SwiftUI

struct CustomTabView<Content: View>: View {
    let tabs: [TabItemData]
    @Binding
    var selectedIndex: Int
    @ViewBuilder
    let content: (Int) -> Content

    var body: some View {
        ZStack {
            TabView(selection: $selectedIndex) {
                ForEach(tabs.indices) { index in
                    content(index)
                        .tag(index)
                }
            }
            VStack {
                Spacer()
                TabBottomView(tabbarItems: tabs, selectedIndex: $selectedIndex)
            }
        }.ignoresSafeArea()
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView(tabs: [
            TabItemData(image: "ic_home_selected"),
            TabItemData(image: "ic_stats"),
            TabItemData(image: "ic_summary"),
            TabItemData(image: "ic_settings")
        ], selectedIndex: .constant(0), content: { _ in })
    }
}

enum TabType: Int, CaseIterable {
    case home = 0
    case stats
    case quiz
    case settings

    var tabItem: TabItemData {
        switch self {
        case .home:
            return TabItemData(image: "ic_home_selected")
        case .stats:
            return TabItemData(image: "ic_stats")
        case .quiz:
            return TabItemData(image: "ic_summary")
        case .settings:
            return TabItemData(image: "ic_settings")
        }
    }
}
