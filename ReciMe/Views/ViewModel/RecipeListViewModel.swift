//
//  RecipeListViewModel.swift
//  ReciMe
//
//  Created by Yeshua Lagac on 1/14/23.
//

import SwiftUI

@MainActor class RecipeListViewModel: ObservableObject {
    
    @Published var recipes: [Recipe]? = nil
    @Published var selectedRecipe: Recipe? = nil
    @Published var ingredients: [Ingredient] = []
    
    init() {
        getAllRecipesByUser("7NWpTwiUWQMm89GS3zJW7Is3Pej1")
    }
    
    func getAllRecipesByUser(_ userId: String) {
        URLSessionProvider.shared.request([Recipe].self, service: RecipeService.getAllRecipesByUser(userId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    withAnimation {
                        self.recipes = recipes
                    }
                case .failure(let error):
                    self.recipes = []
                    print("ERROR || Failed to fetch all recipes with userId `\(userId)` \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getIngredientsOfRecipe(_ recipeId: String) {
        ingredients.removeAll()
        URLSessionProvider.shared.request([Ingredient].self, service: RecipeService.getIngredients(recipeId)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let ingredients):
                    withAnimation {
                        self.ingredients = ingredients
                        self.saveOriginalIngredientCount()
                    }
                case .failure(let error):
                    self.ingredients = []
                    print("ERROR || Failed to fetch all ingredients with userId `\(recipeId)` \(error.localizedDescription)")
                }
            }
        }
    }
    
    func computeIngredients(currentServing: Int, isAdd: Bool) {
        ingredients.forEach { ingredient in
            if let index = ingredients.firstIndex(where: { $0.tempId == ingredient.tempId}), let selectedRecipe {
                ingredients[index].quantity = (ingredients[index].displayQuantity ?? 0) * (Double(currentServing) / selectedRecipe.servingSize)
            }
        }
    }
    
    func saveOriginalIngredientCount() {
        ingredients.forEach { ingredient in
            if let index = ingredients.firstIndex(where: { $0.tempId == ingredient.tempId}) {
                ingredients[index].displayQuantity = ingredients[index].quantity
            }
        }
    }
    
}
