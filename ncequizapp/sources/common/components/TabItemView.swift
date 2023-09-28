import SwiftUI

struct TabItemView: View {
    let data: TabItemData
    let isSelected: Bool

    var body: some View {
        VStack {
            Image(data.image)
                .renderingMode(.template)
        }
        .foregroundColor(isSelected ? Color.purpleRegular : Color.medGray)
        .frame(maxWidth: .infinity)
    }
}

struct TabItemView_Previews: PreviewProvider {
    static var previews: some View {
        TabItemView(data: TabItemData(image: "ic_home_selected"), isSelected: true)
    }
}
