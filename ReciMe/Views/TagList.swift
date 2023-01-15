//
//  TagListView.swift
//  ReciMe
//
//  Created by Yeshua Lagac on 1/15/23.
//

import SwiftUI

struct TagList: View {
    let tags: [String]
    
    var body: some View {
        generateTags()
    }
    
    private func generateTags() -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        return ZStack(alignment: .topLeading) {
            ForEach(tags, id: \.self) { tag in
                Tag(tag: tag)
                    .alignmentGuide(.leading, computeValue: { tagSize in
                        if (abs(width - tagSize.width) > UIScreen.main.bounds.size.width - 20) {
                            width = 0
                            height -= tagSize.height
                        }
                        let offset = width
                        if tag == tags.last ?? "" {
                            width = 0
                        } else {
                            width -= tagSize.width
                        }
                        return offset
                    })
                    .alignmentGuide(.top, computeValue: { tagSize in
                        let offset = height
                        if tag == tags.last ?? "" {
                            height = 0
                        }
                        return offset
                    })
            }
        }
        .background(GeometryReader { geo in
            Color.white.onAppear {
                height = geo.size.height
            }
        })
    }
}


struct Tag: View {
    var tag: String
    @State var fontSize: CGFloat = 20.0
    @State var iconSize: CGFloat = 20.0
    
    var body: some View {
        HStack {
            AppText(tag, size: 12, color: .white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 7)
        .background(Capsule().fill(Color.orange))
        .padding(5)
    }
}

