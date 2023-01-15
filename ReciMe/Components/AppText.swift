//
//  AppText.swift
//  ReciMe
//
//  Created by Yeshua Lagac on 1/14/23.
//

import SwiftUI

struct AppText: View {
    
    var text: String
    var weight: AppFonts = .regular
    var size: CGFloat = 16.0
    var color: Color
    var lineSpacing: CGFloat = 6
    @Binding var isLoading: Bool
    var shimmerWidth: CGFloat
    var alignment: TextAlignment
    
    init(_ text: String, weight: AppFonts = .regular, size: CGFloat = 16.0, color: Color = .grey1, isLoading: Binding<Bool> = .constant(false), shimmerWidth: CGFloat = 100, lineSpacing: CGFloat = 6, alignment: TextAlignment = .leading) {
        self.text = text
        self.weight = weight
        self.size = size
        self.color = color
        self._isLoading = isLoading
        self.shimmerWidth = shimmerWidth
        self.lineSpacing = lineSpacing
        self.alignment = alignment
    }
    
    @ViewBuilder
    var body: some View {
        if isLoading {
            RoundedRectangle(cornerRadius: 3.0)
                .fill(Color.white)
                .frame(width: shimmerWidth, height: size)
                .shimmering()
        } else {
            Text(text).font(.app(size: size, weight: weight)).multilineTextAlignment(alignment).foregroundColor(color).lineSpacing(lineSpacing)
        }
    }
}

extension Font {
    public static func app(size: CGFloat, weight: AppFonts = .regular) -> Font {
        return Font.custom(weight.rawValue, size: size)
    }
}

#if DEBUG
struct AppTextContainerPreview: View {
    @State var isLoading = false
    var body: some View {
        VStack {
            AppText("HELLOWsssssss", isLoading: $isLoading)
            Button("Change") {
                isLoading.toggle()
            }
        }
    }
}

struct AppText_Preview: PreviewProvider {
    static var previews: some View {
        AppTextContainerPreview()
    }
}
#endif

