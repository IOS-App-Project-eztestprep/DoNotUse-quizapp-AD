import AVFoundation
import MessageUI
import SwiftUI
import UIKit

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode)
    var presentation
    @Binding
    var result: Result<MFMailComposeResult, Error>?
    var recipients = [String]()
    var subscriberId: String?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding
        var presentation: PresentationMode
        @Binding
        var result: Result<MFMailComposeResult, Error>?

        init(
            presentation: Binding<PresentationMode>,
            result: Binding<Result<MFMailComposeResult, Error>?>
        ) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(
            _: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)

            if result == .sent {
                AudioServicesPlayAlertSound(SystemSoundID(1001))
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(
            presentation: presentation,
            result: $result
        )
    }

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<MailView>
    )
        -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients(recipients)
        vc.setSubject("CLEP Issue report")
        vc.setMessageBody(generateMessage(), isHTML: false)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(
        _: MFMailComposeViewController,
        context _: UIViewControllerRepresentableContext<MailView>
    ) {}
}

extension MailView {
    private func generateMessage() -> String {
        "🚨ISSUE REPORT🚨\n\n"
            +
            "Hello Team Peterson's! 👋\n\n"
            +
            "Here's a detailed description of my issue:\n\n"
            +
            "<Type your message here>\n\n\n"
            +
            "⚠️ Please do not remove below data.\n"
            +
            "It makes problem-solving faster and easier. 💪\n"
            +
            "App version: v\(UIApplication.version) (\(UIApplication.buildNumber))\n"
            +
            "SubscriberId: \(subscriberId ?? "not subscribed")"
    }
}
