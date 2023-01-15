//
//  RecipeDetailView.swift
//  ReciMe
//
//  Created by Yeshua Lagac on 1/14/23.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    var namespace: Namespace.ID
    @State private var currentServing: Int = 1
    @State private var stepsIndex: Int = 1
    @EnvironmentObject var viewModel: RecipeListViewModel

    var body: some View {
        VStack {
            HStack {
                AppText(recipe.title, weight: .extraBold, size: 30)
                Spacer()
                Button {
                    withAnimation(.spring()) {
                        viewModel.selectedRecipe = nil
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.black)
                }
                
            }
            .padding(.horizontal, 20)
            ScrollView {
                VStack (alignment: .leading, spacing: 20){
                    creatorView
                    HStack (spacing: 20){
                        tabSectionView(title: "Prep time", description: recipe.prepTimeDisplay)
                        if let cookTime = recipe.cookTimeDisplay {
                            tabSectionView(title: "Cook time", description: cookTime)
                        }
                        tabSectionView(title: "Difficulty", description: recipe.difficulty.display)
                    }
                
                    URLImage(recipe.imageUrl)
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.size.width, height: 300)
                        .clipped()
                        .padding(.horizontal, -20)
                    
                    if let description = recipe.description {
                        aboutSection(description: description)
                    }
                    
                    ingredientsSection
                    
                    methodsView

                    tags

                }
                .padding(.horizontal, 20)

            }
        }
        .matchedGeometryEffect(id: recipe.imageUrl, in: namespace)
        .onAppear {
            currentServing = Int(recipe.servingSize)
            viewModel.getIngredientsOfRecipe(recipe.id)
        }
        .transition(.scale(scale: 0.1))
        
    }
    
    func aboutSection(description: String) -> some View{
        VStack (alignment: .leading, spacing: 5){
            AppText("About", weight: .medium, size: 20)
            AppText(description, size: 16)
        }
    }
    var creatorView: some View {
        HStack (spacing: 4){
            AvatarView(imageURL: recipe.creator.profileImageUrl, size: 40)
            AppText("by").padding(.leading, 4)
            AppText(recipe.creator.username, weight: .semiBold, color: .orange)
        }
    }
    
    func tabSectionView(title: String, description: String) -> some View {
        VStack (alignment: .leading, spacing: 8){
            AppText(title, weight: .medium, size: 16)
            AppText(description, weight: .semiBold, size: 20)
        }
    }
    
    var ingredientsSection: some View {
        VStack (alignment: .leading){
            sectionTitle(title: "Ingredient")
            HStack (spacing: 10){
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(currentServing <= 1 ? Color.grey4.opacity(0.4) : Color.orange)
                    .onTapGesture {
                        if currentServing > 1 {
                            currentServing -= 1
                        }
                        viewModel.computeIngredients(currentServing: currentServing, isAdd: false)
                    }
                    .disabled(currentServing <= 1)
                AppText("\(currentServing) serving\(currentServing > 1 ? "s" : "")", size: 16)
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color.orange)
                    .onTapGesture {
                        currentServing += 1
                        viewModel.computeIngredients(currentServing: currentServing, isAdd: true)
                    }
            }
            .padding(.bottom, 20)
            
            VStack (alignment: .leading, spacing: 20){
                ForEach(viewModel.ingredients, id: \.tempId) { ingredient in
                    if let header = ingredient.heading {
                        AppText(header, weight: .bold, size: 18)
                            .padding(.top, 10)
                            .padding(.bottom, -10)
                    } else {
                        HStack (spacing: 10){
                            Image(systemName: "fork.knife")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.grey2)
                            VStack (alignment: .leading){
                                HStack (spacing: 3){
                                    if let quantity = ingredient.quantity, quantity > 0 {
                                        AppText(quantity.toFractionString, weight: .bold, size: 18)
                                    }
                                    
                                    if let unit = ingredient.unit, !unit.isEmpty {
                                        AppText(unit, weight: .bold, size: 18)
                                    }
                                    
                                    if let productModifier = ingredient.productModifier, !productModifier.isEmpty {
                                        AppText(productModifier, weight: .bold, size: 18)
                                    }
                                    
                                    AppText(ingredient.rawProduct, size: 18)
                                }
                                
                                if !ingredient.preparationNotes.isEmpty {
                                    AppText(ingredient.preparationNotes, size: 14)
                                }
                            }
                            Spacer()
                        }
                    }
                }
            }
            
        }
    }
    
    var tags: some View {
        VStack (alignment: .leading, spacing: 10){
            sectionTitle(title: "Tags")
            TagList(tags: recipe.tags)
        }
    }
    
    func sectionTitle(title: String) -> some View{
        AppText(title, weight: .bold, size: 24, color: .orange)
    }
    
    var methodsView: some View {
        VStack (alignment: .leading, spacing: 5){
            sectionTitle(title: "Method")
            .padding(.bottom, 5)
            let steps = recipe.method.components(separatedBy: "##").filter({$0 != ""})
            ForEach(steps, id: \.self) { step in
                let groupedSteps = step.components(separatedBy: "\n")
                if !groupedSteps.isEmpty {
                    ForEach(0...groupedSteps.count - 1, id: \.self) { index in
                        let thisStep = groupedSteps[index]
                        if thisStep.hasPrefix(" ") {
                            AppText(String(thisStep.dropFirst()), weight: .bold, size: 20)
                                .padding(.top, 10)
                        } else {
                            if !thisStep.isEmpty {
                                AppText("Step \(index + (groupedSteps[0].hasPrefix(" ") ? 0 : 1))", weight: .semiBold, size: 18, color: .grey2)
                                        .padding(.top, 10)
                                AppText(thisStep, size: 16)
                            }
                        }
                    }
                }
            }
        }
    }

}

struct RecipeDetailView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        RecipeDetailView(recipe: .mock, namespace: namespace)
    }
}


