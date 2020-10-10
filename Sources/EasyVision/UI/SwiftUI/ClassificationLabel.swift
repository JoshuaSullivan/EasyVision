import SwiftUI

/// A view which presents a classification label and its associated confidence.
///
public struct ClassificationLabel: View {

    /// The classification to display.
    ///
    public var classification: Classification

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text(classification.label)
                .font(.subheadline)
            Spacer()
            Text(String(format: "%0.1f%%", arguments: [classification.confidence * 100.0]))
                .font(Font.subheadline.monospacedDigit())
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
        VStack {
            ClassificationLabel(classification: Classification(label: "Fish", confidence: 0.675))
            ClassificationLabel(classification: Classification(label: "Cat", confidence: 1.0))
            ClassificationLabel(classification: Classification(label: "Dog", confidence: 0.046))
        }.padding()
    }
}
