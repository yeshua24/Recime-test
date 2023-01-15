//
//  AvatarView.swift
//  ReciMe
//
//  Created by Yeshua Lagac on 1/14/23.
//

import SwiftUI

struct AvatarView: View {
    private var image: UIImage? = nil
    private var urlString: String? = nil
    var contentMode : ContentMode
    
    var size: CGFloat
    var borderColor: Color = .grey5
    var borderWidth: CGFloat = 2
    
    private var noImageFound: Bool {
        if (image == nil && urlString == nil) {
            return true
        } else if let urlString = urlString,
                  urlString.isEmpty || URL(string: urlString) == nil {
            return true
        }
        return false
    }
    
    private init(image: UIImage?, urlString: String?, size: CGFloat, contentMode: ContentMode = .fill, borderColor: Color, borderWidth: CGFloat) {
        self.image = image
        self.size = size
        self.urlString = urlString
        self.contentMode = contentMode
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
    
    init(imageName: String, size: CGFloat = 80, borderColor: Color = Color.gray.opacity(0.2), borderWidth: CGFloat = 2) {
        guard let image = UIImage(named: imageName)
        else {
            self.init(image: nil, urlString: nil, size: size, borderColor: borderColor, borderWidth: borderWidth)
            return
        }
        self.init(image: image, urlString: nil, size: size, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    init(imageURL urlString: String?, size: CGFloat = 80, contentMode: ContentMode = .fill, borderColor: Color = Color.gray.opacity(0.2), borderWidth: CGFloat = 2) {
        guard let urlString = urlString
        else {
            self.init(image: nil, urlString: nil, size: size, contentMode: contentMode, borderColor: borderColor, borderWidth: borderWidth)
            return
        }
        self.init(image: nil, urlString: urlString, size: size, contentMode: contentMode, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    init(image: UIImage?, size: CGFloat = 80, borderColor: Color = Color.gray.opacity(0.2), borderWidth: CGFloat = 2) {
        self.init(image: image, urlString: nil, size: size, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    var body: some View {
        if noImageFound {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .modifier(AvatarModifiers(size: size))
                .foregroundColor(.grey4)
                .overlay(Circle().stroke(borderColor, lineWidth: borderWidth))
                .background(Circle().fill(Color.white))
        } else if let image = image {
            Image(uiImage: image)
                .resizable()
                .modifier(AvatarModifiers(size: size))
                .overlay(Circle().stroke(borderColor, lineWidth: borderWidth))
        } else {
            ZStack {
                Group {
                    URLImage(urlString!)
                        .aspectRatio(contentMode: contentMode)
                }
                .frame(width: size, height: size)
                .clipShape(Circle())
                Circle().stroke(borderColor, lineWidth: borderWidth)
                    .frame(width: size, height: size)
            }

        }
    }
    
    private struct AvatarModifiers: ViewModifier {
        let size: CGFloat
        func body(content: Content) -> some View {
            content
                .clipped()
                .clipShape(Circle())
                .frame(width: size, height: size)
        }
    }
}

#if DEBUG
struct Avatar_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            AvatarView(imageURL: "https://i0.wp.com/cdn-prod.medicalnewstoday.com/content/images/articles/326/326507/a-sat-in-bed-wondering-a-about-male-discharge-non-std.jpg?w=1155&h=1730")
            AvatarView(imageURL: nil)
        }
    }
}
#endif
