import SwiftUI

class SnapCarouselv2Constants {
    static let CARD_HEIGHT_IPHONE = 146.0
    static let CARD_HEIGHT_IPAD = 210.0
    
    static let CARD_WIDTH_IPHONE = 75.0
    static let CARD_WIDTH_IPAD = 172.0
    
    static let CARD_SPACING_IPHONE = 16.0
    static let CARD_SPACING_IPAD = 32.0
    
    static let CARD_TITLE_BASE_FONT_SIZE = 20.0
    static let CARD_TITLE_FONT_SIZE_IPAD = CARD_TITLE_BASE_FONT_SIZE * 1.5
    
    static let SPACING: CGFloat = UIScreen.iPad ? CARD_SPACING_IPAD : CARD_SPACING_IPHONE
    static let WIDTH_OF_HIDDEN_CARDS: CGFloat = UIScreen.iPad ? CARD_WIDTH_IPAD : CARD_WIDTH_IPHONE /// UIScreen.main.bounds.width - 10
    static let CARD_HEIGHT: CGFloat = UIScreen.iPad ? CARD_HEIGHT_IPAD : CARD_HEIGHT_IPHONE
}

struct SnapCarouselv2: View {
    @EnvironmentObject
    var UIState: UIStateModel
    let items: [Card]

    var body: some View {
        let spacing: CGFloat = UIScreen.iPad ? 32 : 16
        let widthOfHiddenCards: CGFloat = UIScreen.iPad ? 140 : 60 /// UIScreen.main.bounds.width - 10
        let cardHeight: CGFloat = UIScreen.iPad ? 330 : 165
        return Canvas {
            VStack {
                Carousel(numberOfItems: CGFloat(items.count), spacing: spacing, widthOfHiddenCards: widthOfHiddenCards) {
                        ForEach(items, id: \.self.id) { item in

                            Item(_id: Int(item.id), spacing: spacing, widthOfHiddenCards: widthOfHiddenCards, cardHeight: cardHeight) {
                                VStack(alignment: .center, spacing: 10) {
                                        Text("\(item.quizType.title)")
                                            .font(Font.nunito(.bold, size: UIScreen.iPad ? 30 : 24))
                                            .foregroundColor(.text)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(nil)
                                        item.quizType.icon?
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: UIScreen.iPad ? 50 : 30, height: UIScreen.iPad ? 50 : 30)
                                            .foregroundColor(.white)
                                    if item.isUnlocked {
                                        HStack(alignment: .center) {
                                            Text(item.subtitle)
                                                .font(Font.roboto(.bold, size: UIScreen.iPad ? 18 : 12))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(item.secondaryColor ? Color.text : Color.text)
                                                .lineLimit(nil)
                                        }
                                    }
                                }.padding(UIScreen.iPad ? 60 : 20)
                            }
                            .foregroundColor(Color.textColor)
                            .background(item.isEnabled ? Color.lightBlue : Color.backgroundButton)
                            .cornerRadius(UIScreen.iPad ? 40 : 20)
                            .transition(AnyTransition.slide)
                            .animation(.spring())
                            .onTapGesture {
                                if item.isEnabled {
                                    item.action?()
                                }
                            }
                            .id(item.id)
                        }
                }
                .environmentObject(self.UIState)
                .shadow(color: .medGray, radius: 4, x: 0, y: 4)
                
                HStack(spacing: 8) {
                    ForEach(items.indices, id: \.self) { index in
                        Capsule()
                            .fill(UIState.contentOffset == index ? Color.textSubtitle : Color.lightPurple)
                            .frame(width: UIState.contentOffset == index ? 20 : 7, height: 7 )
                            .scaleEffect(UIState.contentOffset == index ? 1.1 : 1)
                            .animation(.spring(), value: UIState.contentOffset == index)
                    }
                }.padding(.top, 16.0)
            }
        }
        .padding(.horizontal, 16.0)
    }
    
}

struct Card: Identifiable {
    var id: Int
    var quizType: QuizType
//    var subtitle: String?
    var action: (() -> Void)?
    var isEnabled: Bool = true
    var counterValue: Int?
    var isQuizList: Bool = false
    var isUnlocked: Bool = true

    var secondaryColor: Bool {
        !isEnabled || !isUnlocked
    }

    var subtitle: String {
        switch quizType {
        case .bookmarked:
            return !isQuizList ?
                "REVIEW SAVED QUESTIONS" :
                "Return to questions you've saved"
        case .daily:
            return isEnabled ?
                (
                    counterValue != nil ? "\(counterValue!) quizzes completed"
                        .uppercased() : ""
                ) : "COMPLETED - COME BACK TOMORROW"
        case .missed:
            return !isQuizList ? "\(counterValue ?? 0) missed questions"
                .uppercased() : "Review questions you've missed"
        case .random:
            return "\(counterValue ?? 0) questions completed.".uppercased()
        case .timed:
            return "40 QUESTIONS, 30 MINUTES" //"\(counterValue ?? 0) quizzes completed.".uppercased()
        default:
            return ""
        }
    }

    var icon: Image? {
        switch quizType {
        case .daily:
            return isEnabled ? Image("starsIcon").renderingMode(.template) : nil
        case .random, .timed:
            return Image("starsIcon").renderingMode(.template)
        default:
            return nil
        }
    }
}

public class UIStateModel: ObservableObject {
    @Published
    var activeCard: Int = 0
    @Published
    var screenDrag: Float = 0.0

    var shouldResetPosition: Bool = true
    @Published
    var contentOffset: Int = 0
    @Published
    var contentOffsetCategory: Int = 0

    init(activeCard: Int, screenDrag: Float) {
        self.activeCard = activeCard
        self.screenDrag = screenDrag
    }
}

struct Carousel<Items: View>: View {
    let items: Items
    let numberOfItems: CGFloat // = 8
    let spacing: CGFloat // = 16
    let widthOfHiddenCards: CGFloat // = 32
    let totalSpacing: CGFloat
    let cardWidth: CGFloat

    @GestureState
    var isDetectingLongPress = false

    @EnvironmentObject
    var UIState: UIStateModel

    @inlinable
    public init(
        numberOfItems: CGFloat,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        @ViewBuilder _ items: () -> Items
    ) {
        self.items = items()
        self.numberOfItems = numberOfItems
        self.spacing = spacing
        self.widthOfHiddenCards = widthOfHiddenCards
        totalSpacing = (numberOfItems - 1) * spacing
        cardWidth = UIScreen
            .screenWidth - (widthOfHiddenCards * 2) - (spacing * 2) // 279
    }

    func calculatePageIndex( offset: CGFloat)-> Int{
        var index = 0
        
        if UIScreen.iPad {
            if (offset > 1050.0){
                index = 0
            } else if (offset < 1040.0 && offset > 480.0){
                index = 1
            } else if (offset < 480.0 && offset > -80.0){
                index = 2
            } else if (offset < -80.0 && offset > -490.0){
                index = 3
            } else if (offset < -490.0){
                index = 4
            }
            
        } else if UIScreen.isSmallScreenIphone {
            if (offset > 460.0){
                index = 0
            } else if (offset < 460.0 && offset > 245.0){
                index = 1
            } else if (offset < 245.0 && offset > -50.0){
                index = 2
            } else if (offset < -50.0 && offset > -210.0){
                index = 3
            } else if (offset < -210.0){
                index = 4
            }
            
        } else if UIScreen.isProMaxIphone {
            if (offset > 500.0){
                index = 0
            } else if (offset < 500.0 && offset > 220.0){
                index = 1
            } else if (offset < 220.0 && offset > -35.0){
                index = 2
            } else if (offset < -35.0 && offset > -245.0){
                index = 3
            } else if (offset < -245.0){
                index = 4
            }
            
        } else {
            
            if (offset > 460.0){
                index = 0
            } else if (offset < 460.0 && offset > 220.0){
                index = 1
            } else if (offset < 220.0 && offset > -35.0){
                index = 2
            } else if (offset < -35.0 && offset > -245.0){
                index = 3
            } else if (offset < -245.0){
                index = 4
            }
            
        }
        
        return index
    }
    func calculateCategoryPageIndex( offset: CGFloat)-> Int{
        var index = 0
        
        if UIScreen.iPad {
            if (offset > 1760.0){
                index = 0
            } else if (offset < 1760.0 && offset > 1245.0){
                index = 1
            } else if (offset < 1245.0 && offset > 735.0){
                index = 2
            } else if (offset < 735.0 && offset > 190.0){
                index = 3
            } else if (offset < 190.0 && offset > -350.0){
                index = 4
            } else if (offset < -350.0 && offset > -920.0){
                index = 5
            } else if (offset < -920.0 && offset > -1150.0){
                index = 6
            } else if (offset < -1150.0){
                index = 7
            }
                        
            return index
        } else if UIScreen.isSmallScreenIphone {
            if (offset < 1050.0 && offset > 820.0){
                index = 0
            } else if (offset < 820.0 && offset > 580.0){
                index = 1
            } else if (offset < 580.0 && offset > 350.0){
                index = 2
            } else if (offset < 350.0 && offset > 95.0){
                index = 3
            } else if (offset < 95.0 && offset > -140.0){
                index = 4
            } else if (offset < -140.0 && offset > -370.0){
                index = 5
            } else if (offset < -370.0 && offset > -600.0){
                index = 6
            } else if (offset < -600.0 && offset > -890.0){
                index = 7
            }
                        
            return index
        } else if UIScreen.isProMaxIphone {
            if (offset < 1050.0 && offset > 960.0){
                index = 0
            } else if (offset < 960.0 && offset > 665.0){
                index = 1
            } else if (offset < 665.0 && offset > 385.0){
                index = 2
            } else if (offset < 385.0 && offset > 110.0){
                index = 3
            } else if (offset < 110.0 && offset > -190.0){
                index = 4
            } else if (offset < -190.0 && offset > -480.0){
                index = 5
            } else if (offset < -480.0 && offset > -760.0){
                index = 6
            } else if (offset < -760.0 && offset > -890.0){
                index = 7
            }
                        
            return index
        } else {
            if (offset < 1050.0 && offset > 860.0){
                index = 0
            } else if (offset < 860.0 && offset > 610.0){
                index = 1
            } else if (offset < 610.0 && offset > 360.0){
                index = 2
            } else if (offset < 360.0 && offset > 110.0){
                index = 3
            } else if (offset < 110.0 && offset > -140.0){
                index = 4
            } else if (offset < -140.0 && offset > -390.0){
                index = 5
            } else if (offset < -390.0 && offset > -500.0){
                index = 6
            } else if (offset < -500.0 && offset > -890.0){
                index = 7
            }
                        
            return index
        }
    }
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollViewWrapper(axes: .horizontal, showsIndicators: false, offsetChanged: { offset in
                if numberOfItems == 8 {
                    UIState.contentOffsetCategory = calculateCategoryPageIndex(offset: offset.x)
                }else {
                    UIState.contentOffset = calculatePageIndex(offset: offset.x)
                }
            }) {
                HStack(alignment: .center, spacing: spacing) {
                    items
                }.padding(.bottom, 8)
            }
            .onAppear {
                if UIState.shouldResetPosition {
                    UIState.shouldResetPosition = false
                    withAnimation {
                        scrollView.scrollTo(UIState.activeCard, anchor: .center)
                    }
                }
            }
        }
    }
}

struct Canvas<Content: View>: View {
    let content: Content
    @EnvironmentObject
    var UIState: UIStateModel

    @inlinable
    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: UIScreen.iPad ? 360 : 180,
                alignment: .center
            )
    }
}

struct Item<Content: View>: View {
    @EnvironmentObject
    var UIState: UIStateModel
    let cardWidth: CGFloat
    let cardHeight: CGFloat

    var _id: Int
    var content: Content

    @inlinable
    public init(
        _id: Int,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        cardHeight: CGFloat,
        @ViewBuilder _ content: () -> Content
    ) {
        self.content = content()
        cardWidth = UIScreen
            .screenWidth - (widthOfHiddenCards * 2) - (spacing * 2) // 279
        self.cardHeight = cardHeight
        self._id = _id
    }

    var body: some View {
        content
            .frame(
                width: cardWidth,
                height: cardHeight - 10,
                alignment: .center
            )
    }
}

struct SnapCarousel_Previews: PreviewProvider {
    static var previews: some View {
        SnapCarouselv2(items: [
            Card(id: 0, quizType: .random),
            Card(id: 1, quizType: .bookmarked),
            Card(id: 2, quizType: .daily),
            Card(id: 3, quizType: .missed),
            Card(id: 4, quizType: .timed)
        ]).environmentObject(UIStateModel(activeCard: 0, screenDrag: 0.0))
    }
}
