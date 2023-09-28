import SwiftUI

struct StreakNotificationView: View, Loggable {
    @Environment(\.presentationMode)
    var presentationMode
    var streakLevel: StreakLevel = .five

    var body: some View {
        ZStack {
            Color.init(red: 0, green: 0, blue: 0, opacity: 0.1)
                .ignoresSafeArea()
            VStack(spacing: 15) {
//                HStack {
//                    Spacer()
//                    Button {
//                        presentationMode.wrappedValue.dismiss()
//                    } label: {
//                        Image("ic_back")
//                            .padding(.trailing, 10)
//                    }
//                }
//                ZStack {
                    Image("img_streak")
                        .resizable()
                        .frame(width: 175, height: 175)
//                    VStack {
//                        Text("\(streakLevel.number)")
//                            .font(Font.nunito(.regular, size: 30))
//                            .foregroundColor(.text)
//                        Text("Day Streak")
//                            .font(Font.nunito(.regular, size: UIScreen.iPad ? 12 : 8))
//                            .foregroundColor(.text)
//                    }
//                    .padding(.top, 45)
//                }
                Text(
                    "**\(streakLevel.title)**\nYou've studied for\n\(streakLevel.number) days in a row.\n\nKeep it up to set a new\n streak record!"
                )
                .font(Font.nunito(.regular, size: 20))
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .foregroundColor(.text)
                RoundedButtonWithAction(text: "Keep Going!", isSelectable: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(EdgeInsets.init(top: 0, leading: 30, bottom: 30, trailing: 30))
               
            }.background(.white)
                .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .cornerRadius(20)
            .onAppear {
                logScreen(self)
            }
        }
    }
}

struct StreakNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        StreakNotificationView()
    }
}

extension StreakNotificationView {
    enum StreakLevel {
        case three, five, seven, fourteen

        var number: Int {
            switch self {
            case .three: return 3
            case .five: return 5
            case .seven: return 7
            case .fourteen: return 14
            }
        }

        var title: String {
            switch self {
            case .three:
                return "You're on a roll!"
            case .five:
                return "You're a rockstar!"
            case .seven:
                return "Incredible!"
            case .fourteen:
                return "You've officially won studying!"
            }
        }

        init?(number: Int) {
            switch number {
            case 3:
                self = .three
            case 5:
                self = .five
            case 7:
                self = .seven
            case 14:
                self = .fourteen
            default:
                return nil
            }
        }
    }
}
