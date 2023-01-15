//
//  RecipeService.swift
//  ReciMe
//
//  Created by Yeshua Lagac on 1/14/23.
//

import Foundation

enum RecipeService: ServiceProtocol {
    
    case getAllRecipesByUser(String)
    case getIngredients(String)
    var path: String {
        switch self {
        case let .getAllRecipesByUser(userId):
            return "profile/\(userId)/posts"
        case let .getIngredients(recipeId):
            return "recipe/\(recipeId)/ingredients"

        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    var needsAuthentication: Bool {
        switch self {
        default:
            return false
        }
    }
    
    var usesContainer: Bool {
        switch self {
        default:
            return false
        }
    }
    
    var parametersEncoding: ParametersEncoding {
        switch self {
        default:
            return .json
        }
    }
}

