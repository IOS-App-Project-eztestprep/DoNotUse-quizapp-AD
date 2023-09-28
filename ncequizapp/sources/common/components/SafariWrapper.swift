import SafariServices
import SwiftUI

struct SFSafariViewWrapper: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(
        context _: UIViewControllerRepresentableContext<Self>
    )
        -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(
        _: SFSafariViewController,
        context _: UIViewControllerRepresentableContext<SFSafariViewWrapper>
    ) {}
}
