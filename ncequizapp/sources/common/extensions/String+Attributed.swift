import UIKit

extension String {
    var attributedAnswer: AttributedString {
        let modifiedFont = String(
            format: "<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(UIFont.systemFont(ofSize: 12).pointSize)\">%@</span>",
            self
        )

        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(
                using: .unicode,
                allowLossyConversion: true
            )!,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )

        return AttributedString(attrStr)
    }

    var attributedQuestion: AttributedString {
        let modifiedFont = String(
            format: "<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(UIFont.systemFont(ofSize: 20).pointSize)\">%@</span>",
            self
        )

        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(
                using: .unicode,
                allowLossyConversion: true
            )!,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )

        return AttributedString(attrStr)
    }

    var attributedExplanation: AttributedString {
        let modifiedFont = String(
            format: "<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(UIFont.systemFont(ofSize: 12).pointSize)\">%@</span>",
            self
        )

        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(
                using: .unicode,
                allowLossyConversion: true
            )!,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )

        return AttributedString(attrStr)
    }
}
