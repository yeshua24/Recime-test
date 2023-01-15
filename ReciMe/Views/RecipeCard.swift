//
//  RecipeCard.swift
//  ReciMe
//
//  Created by Yeshua Lagac on 1/14/23.
//

import SwiftUI

struct RecipeCard: View {

    let recipe: Recipe
    var namespace: Namespace.ID

    var body: some View {
        VStack (alignment: .leading, spacing: 15){
            
            URLImage(recipe.imageUrl)
                .scaledToFill()
                .frame(width: (UIScreen.main.bounds.size.width / 2) - 20, height: 230)
                .cornerRadius(20)
                .clipped()
                .overlay(detailsOverlay)
                .shadow(color: .gray.opacity(0.4), radius: 20, x: 0, y: 2)
                .matchedGeometryEffect(id: recipe.imageUrl, in: namespace)

            
            AppText(recipe.title, weight: .semiBold, size: 18).lineLimit(1)

        }
    }
    
    var detailsOverlay: some View {
        ZStack (alignment: .bottom){
            LinearGradient(colors: [.black.opacity(0.3), .black.opacity(0.1), .clear], startPoint: .bottom, endPoint: .top).cornerRadius(15)
            HStack {
                HStack (spacing: 4){
                    Image(systemName: "clock.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                        .foregroundColor(.yellow)
                    AppText("\(Double((recipe.prepTime) + (recipe.cookTime ?? 0)).asString(style: .abbreviated))", weight: .black, color: .white)
                }
                Spacer()
                HStack (spacing: 6){
                    Image(systemName: "bookmark.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10)
                        .foregroundColor(.yellow)
                    AppText("\(recipe.numSaves)", weight: .black, color: .white)
                }
            }
            .padding()
        }
    }
}

struct RecipeCard_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        RecipeCard(recipe: .mock, namespace: namespace)
            .previewLayout(.sizeThatFits)
    }
}

struct RecipeCardLoading: View {
    var body: some View {
        VStack (alignment: .leading, spacing: 15){
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.grey6)
                .frame(width: (UIScreen.main.bounds.size.width / 2) - 20, height: 230)
                .shimmering()
            
            RoundedRectangle(cornerRadius: 9)
                .fill(Color.grey6)
                .frame(width: CGFloat.random(in: 120..<(UIScreen.main.bounds.size.width / 2) - 20), height: 18)
                .shimmering()
        }
    }
}

struct RecipeCardLoading_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCardLoading()
            .previewLayout(.sizeThatFits)
    }
}
