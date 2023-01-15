//
//  Recipe.swift
//  ReciMe
//
//  Created by Yeshua Lagac on 1/14/23.
//

import Foundation

enum RecipeType: String, Decodable{
    case recipe = "RECIPE"
    var display: String {
        return self.rawValue.capitalized
    }
}

enum Difficulty: String, Decodable {
    case easy = "EASY"
    
    var display: String {
        return self.rawValue.capitalized
    }
}

struct Recipe : Decodable{
    let id: String
    let type: RecipeType
    let title: String
    let description: String?
    let recipeUrl: String?
    let imageUrl: String
    let creator: User
    let cookTime: Double?
    let prepTime: Double
    let servingSize: Double
    let difficulty: Difficulty
    let method: String
    let timestamp: Int
    let liked: Bool
    let saved: Bool
    let numLikes: Int
    let numSaves: Int
    let numComments: Int
    let numRecreates: Int
    let rating: Int
    let tags: [String]
    
    static var mock : Recipe = .init(id: "acb88912-d594-416f-809c-1f4f75f3b03e", type: .recipe, title: "Easy poke bowl", description: "Easiest lunch ever. Great for summer!", recipeUrl: nil, imageUrl: "https://recime-model-1.s3.ap-southeast-2.amazonaws.com/images/f810bf27-acf5-4ad6-b4e1-d693ac9c7f43.jpg", creator: .init(uid: "7NWpTwiUWQMm89GS3zJW7Is3Pej1", username: "codingproject", profileImageUrl: "https://recime-model-1.s3.ap-southeast-2.amazonaws.com/images/152137a2-bb71-4e52-8b2c-242c2e6ce26c.jpg", firstname: "Yeshua", lastname: "Lagac", isFollowing: false), cookTime: 5, prepTime: 10, servingSize: 4, difficulty: .easy, method: """
Make the poke. In a medium bowl, combine fish, soy sauce, sesame oil, sesame seeds, wasabi, shallots and green onions. Toss to mix.
Assemble poke bowl. Add rice to individual bowls and sprinkle with furikake (rice seasoning). Add your favorite vegetable toppings. Drizzle kewpie mayo over the top. Add sriracha to make it a spicy mayo.
Add a dollop of tobiko (fish roe) and crumbled nori over the top. Serve immediately and enjoy.
""", timestamp: 1673418588125, liked: false, saved: false, numLikes: 0, numSaves: 1, numComments: 0, numRecreates: 0, rating: 4, tags: ["Healthy", "Crowd-pleaser", "Entertaining", "Snack", "Dinner", "Lunch", "Side", "Pescatarian"])
    
    var prepTimeDisplay: String {
        return prepTime.asString(style: .abbreviated)
    }
    
    var cookTimeDisplay: String? {
        if let cookTime {
            return cookTime.asString(style: .abbreviated)
        }
        return nil
    }
}
