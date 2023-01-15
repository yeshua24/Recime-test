//
//  Ingredient.swift
//  ReciMe
//
//  Created by Yeshua Lagac on 1/14/23.
//

import Foundation

struct Ingredient: Decodable {
    var tempId = UUID()
    let heading: String?
    let id: Int
    let product: String
    var quantity: Double?
    var displayQuantity: Double? = nil
    let unit: String?
    let productModifier: String?
    let preparationNotes: String
    let imageFileName: String
    let rawText: String
    let rawProduct: String
    let preProcessedText: String
    
    private enum CodingKeys: CodingKey {
        case heading, id, product, quantity, unit, productModifier, preparationNotes, imageFileName, rawText, rawProduct, preProcessedText
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        heading = try container.decodeIfPresent(String.self, forKey: .heading) 
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        quantity = try container.decodeIfPresent(Double.self, forKey: .quantity)
        unit = try container.decodeIfPresent(String.self, forKey: .unit)
        productModifier = try container.decodeIfPresent(String.self, forKey: .productModifier)
        product = try container.decodeIfPresent(String.self, forKey: .product) ?? ""
        preparationNotes = try container.decodeIfPresent(String.self, forKey: .preparationNotes) ?? ""
        imageFileName = try container.decodeIfPresent(String.self, forKey: .imageFileName) ?? ""
        rawText = try container.decodeIfPresent(String.self, forKey: .rawText) ?? ""
        rawProduct = try container.decodeIfPresent(String.self, forKey: .rawProduct) ?? ""
        preProcessedText = try container.decodeIfPresent(String.self, forKey: .preProcessedText) ?? ""
    }
}
