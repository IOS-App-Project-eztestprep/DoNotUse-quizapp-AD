import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    @Binding var shouldAnimate: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let vw = UIActivityIndicatorView()
        vw.color = UIColor.purple
        vw.style = .large
        return vw
    }

    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        DispatchQueue.main.async {
            if self.shouldAnimate {
                uiView.startAnimating()
            } else {
                uiView.stopAnimating()
            }
        }
    }
}

