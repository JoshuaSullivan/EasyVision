import SwiftUI

public struct ClassificationLabel: View {

    public var classification: Classification

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text(classification.label)
                .font(.subheadline)
            Spacer()
            Text(String(format: "%0.1f%%", arguments: [classification.confidence * 100.0]))
                .font(.headline.monospacedDigit())
                .padding(.leading, 16.0)

        }
        .foregroundColor(.white)
        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
        .background(Color.black.opacity(0.7))
        .cornerRadius(8)
    }
}

public struct ClassificationLabel_Previews: PreviewProvider {
    public static var previews: some View {
        ClassificationLabel(classification: Classification(label: "Fish", confidence: 0.675))
    }
}
