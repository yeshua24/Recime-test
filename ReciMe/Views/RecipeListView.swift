//
//  RecipeListView.swift
//  ReciMe
//
//  Created by Yeshua Lagac on 1/14/23.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject var viewModel = RecipeListViewModel()
    @Namespace var namespace: Namespace.ID
    
    var body: some View {
        VStack (spacing: 20) {
            if let selectedRecipe = viewModel.selectedRecipe {
                RecipeDetailView(recipe: selectedRecipe, namespace: namespace).environmentObject(viewModel)
            } else {
                Image("recime")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.orange)
                    .scaledToFit()
                    .frame(height: 40)
                ScrollView {
                    LazyVGrid(columns: .init(repeating: .init(.flexible()), count: 2), alignment: .center, spacing: 40, content: {
                        if let recipes = viewModel.recipes {
                            ForEach(recipes, id: \.id) { recipe in
                                RecipeCard(recipe: recipe, namespace: namespace)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            viewModel.selectedRecipe = recipe
                                        }
                                    }
                            }
                        } else {
                            ForEach(0...10, id: \.self) { _ in
                                RecipeCardLoading()
                            }
                        }
                    })
                    .padding(10)
                }

            }
        }

    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
