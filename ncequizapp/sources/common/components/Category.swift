//
//  Category.swift
//  ncequizapp
//
//  Created by Mahendra Liya on 10/03/23.
//  Copyright © 2023 Mahendra Liya. All rights reserved.
//

import SwiftUI

struct Category: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

enum CategoryType: Equatable {
    case humanGrowth, socialCultural, helping, groupWork, career, assessment, research, professional

    var title: String {
        switch self {
        case .humanGrowth:
            return "Human Growth & Development"
        case .socialCultural:
            return "Social & Cultural Foundations"
        case .helping:
            return "Helping Relationships"
        case .groupWork:
            return "Group Work"
        case .career:
            return "Career Development"
        case .assessment:
            return "Assessment"
        case .research:
            return "Research & Program Eval."
        case .professional:
            return "Professional & Ethical Practice"
        }
    }
}

struct CategoryCard: Identifiable {
    var id: Int
    var categoryType: CategoryType
    var action: (() -> Void)?
    var isEnabled: Bool = true
    var counterValue: Int?
    var isQuizList: Bool = false
    var isUnlocked: Bool = true

    var secondaryColor: Bool {
        !isEnabled || !isUnlocked
    }
}

struct SnapCarouselCategory: View {
    @EnvironmentObject
    var UIState: UIStateModel
    let items: [CategoryCard]
    
    var body: some View {
        let spacing: CGFloat = UIScreen.iPad ? 32 : 16
        let widthOfHiddenCards: CGFloat = UIScreen.iPad ? 120 : 60 /// UIScreen.main.bounds.width - 10
        let cardHeight: CGFloat = UIScreen.iPad ? 330 : 165
        
        return Canvas {
            // TODO: find a way to avoid passing same arguments to Carousel and Item
            Carousel(numberOfItems: CGFloat(items.count), spacing: spacing, widthOfHiddenCards: widthOfHiddenCards
            ) {
                ForEach(items, id: \.self.id) { item in
                    Item(_id: Int(item.id), spacing: spacing,
                        widthOfHiddenCards: widthOfHiddenCards,
                        cardHeight: cardHeight
                    ) {
                        VStack(alignment: .center, spacing: 10.0) {
                            HStack(alignment: .center) {
                                Text("\(item.categoryType.title)")
                                    .font(Font.nunito(.bold, size: UIScreen.iPad ? 30 : 20))
                                    .foregroundColor(.text)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                            }.padding()
                        }.padding(UIScreen.iPad ? 60 : 15)
                    }
                    .foregroundColor(Color.textColor)
                    .background(Color.backgroundCategory)
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
                        .fill(UIState.contentOffsetCategory == index ? Color.textSubtitle : Color.lightPurple)
                        .frame(width: UIState.contentOffsetCategory == index ? 20 : 7, height: 7 )
                        .scaleEffect(UIState.contentOffsetCategory == index ? 1.1 : 1)
                        .animation(.spring(), value: UIState.contentOffsetCategory == index)
                }
            }
        }
        .padding(.horizontal, 16.0)
    }
}

struct Category_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SnapCarouselCategory(items: [
                CategoryCard(id: 0, categoryType: .professional),
                CategoryCard(id: 1, categoryType: .research),
                CategoryCard(id: 2, categoryType: .assessment),
                CategoryCard(id: 3, categoryType: .groupWork),
                CategoryCard(id: 4, categoryType: .helping),
                CategoryCard(id: 5, categoryType: .helping),
                CategoryCard(id: 6, categoryType: .helping),
                CategoryCard(id: 7, categoryType: .helping),
            ]).environmentObject(UIStateModel(activeCard: 0, screenDrag: 0.0))
        }
    }
}
