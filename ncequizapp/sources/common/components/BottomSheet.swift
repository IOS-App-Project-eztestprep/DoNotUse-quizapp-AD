import SwiftUI

class BottomSheetController<Content>: UIHostingController<Content>
where Content: View {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let presentation = sheetPresentationController {
            if #available(iOS 16.0, *) {
                let detent = UISheetPresentationController.Detent
                    .custom(
                        identifier: UISheetPresentationController.Detent
                            .Identifier("bottomSheet")
                    ) { _ in
                        250
                    }
                presentation.detents = [detent]
            } else {
                presentation.detents = [.medium()]
            }
            presentation.preferredCornerRadius = 30
        }
    }
}

struct BottomSheet<Content>: UIViewControllerRepresentable where Content: View {
    private let content: Content
    
    @inlinable
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIViewController(context _: Context)
    -> BottomSheetController<Content> {
        BottomSheetController(rootView: content)
    }
    
    func updateUIViewController(
        _: BottomSheetController<Content>,
        context _: Context
    ) {}
}

struct QuizModeView: View {
    enum QuizMode {
        case learn, test
    }
    
    @Environment(\.dismiss)
    var dismiss
    var quizModeAction: ((QuizMode) -> Void)?
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 10) {
                Text("How do you want to study today?")
                    .font(Font.nunito(.regular, size:14))
                    .foregroundColor(.text)
                Button {
                    dismiss()
                    quizModeAction?(.learn)
                } label: {
                    HStack(spacing: 20) {
                        Image("ic_checklist")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading) {
                            Text("Learn")
                                .font(Font.nunito(.bold, size:14))
                                .fontWeight(.bold)
                                .foregroundColor(.text)
                            Text(
                                "Score your answers immediately\nand review explanation."
                            )
                            .multilineTextAlignment(.leading)
                            .font(Font.nunito(.regular, size:12))
                            .foregroundColor(.buttonGray)
                            .lineLimit(nil)
                            
                        }
                    }.frame(minWidth: UIScreen.screenWidth - 100, minHeight: 80)
                        .background(Color.lightPurple)
                        .cornerRadius(20)
                }
                Button {
                    dismiss()
                    quizModeAction?(.test)
                } label: {
                    HStack(spacing: 20) {
                        Image("ic_sort_by_time")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading) {
                            Text("Test")
                                .font(Font.nunito(.bold, size:14))
                                .fontWeight(.bold)
                                .foregroundColor(.text)
                            Text(
                                "Timed quiz and see your score at\nthe end."
                            )
                            .multilineTextAlignment(.leading)
                            .font(Font.nunito(.regular, size:12))
                            .foregroundColor(.buttonGray)
                            .lineLimit(nil)
                        }
                    }.frame(minWidth: UIScreen.screenWidth - 100, minHeight: 80)
                        .background(Color.lightPurple)
                        .cornerRadius(20)
                }
            }
            .padding(EdgeInsets(
                top: 30,
                leading: 20,
                bottom: 20,
                trailing: 20
            ))
        }.ignoresSafeArea()
    }
}

struct QuizModeViewIpad: View {
    enum QuizMode {
        case learn, test
    }
    
    @Environment(\.dismiss)
    var dismiss
    var quizModeAction: ((QuizMode) -> Void)?
    
    var body: some View {
        Group {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack {
                    Text("How do you want to study today?")
                        .font(Font.nunito(.regular, size:14))
                        .foregroundColor(.text)
                    HStack(alignment: .center) {
                        
                        Button {
                            dismiss()
                            quizModeAction?(.learn)
                        } label: {
                            HStack(spacing: 20) {
                                Image("ic_checklist")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .padding(.leading, 8.0)
                                VStack(alignment: .leading) {
                                    Text("Learn")
                                        .font(Font.nunito(.bold, size:14))
                                        .fontWeight(.bold)
                                        .foregroundColor(.text)
                                    Text(
                                        "Score your answers immediately\nand review explanation."
                                    )
                                    .multilineTextAlignment(.leading)
                                    .font(Font.nunito(.regular, size:12))
                                    .foregroundColor(.buttonGray)
                                    .lineLimit(nil)
                                    .padding(.trailing, 8.0)
                                }
                                .padding(.trailing, 16.0)
                            }.frame(minWidth: UIScreen.screenWidth*0.3, minHeight: 80)
                            .background(Color.lightPurple)
                            .cornerRadius(20)
                        }
                        Button {
                            dismiss()
                            quizModeAction?(.test)
                        } label: {
                            HStack(spacing: 20) {
                                Image("ic_sort_by_time")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .padding(.leading, 8.0)
                                VStack(alignment: .leading) {
                                    Text("Test")
                                        .font(Font.nunito(.bold, size:14))
                                        .fontWeight(.bold)
                                        .foregroundColor(.text)
                                    Text(
                                        "Timed quiz and see your score at\nthe end."
                                    )
                                    .multilineTextAlignment(.leading)
                                    .font(Font.nunito(.regular, size:12))
                                    .foregroundColor(.buttonGray)
                                    .lineLimit(nil)
                                    .padding(.trailing, 8.0)
                                }
                            }.frame(minWidth: UIScreen.screenWidth*0.3, minHeight: 80)
                            .background(Color.lightPurple)
                            .cornerRadius(20)
                        }
                    }
                    
                }.ignoresSafeArea()
                
            }
            
        }.frame(width: UIScreen.screenWidth - 100, height: 200, alignment: .bottom)
    }
    
}
