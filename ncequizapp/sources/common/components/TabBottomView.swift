import SwiftUI

struct TabBottomView: View {
    let tabbarItems: [TabItemData]
    var height: CGFloat = 100
    var width: CGFloat = UIScreen.main.bounds.width
    @Binding
    var selectedIndex: Int

    var body: some View {
        HStack {
            ForEach(tabbarItems.indices) { index in
                let item = tabbarItems[index]
                Button {
                    self.selectedIndex = index
                } label: {
                    let isSelected = selectedIndex == index
                    TabItemView(data: item, isSelected: isSelected)
                }
            }
        }
        .frame(width: width, height: height)
        .background(Color.white)
        .cornerRadius(13)
        .shadow(radius: 5, x: 0, y: -6)
    }
}

struct TabBottomView_Previews: PreviewProvider {
    static var previews: some View {
        TabBottomView(tabbarItems: [
            TabItemData(image: "homeIcon"),
            TabItemData(image: "checkmarkIcon"),
            TabItemData(image: "settingsIcon")
        ], selectedIndex: .constant(0))
    }
}
