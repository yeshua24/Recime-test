//
//  User.swift
//  ReciMe
//
//  Created by Yeshua Lagac on 1/14/23.
//

import Foundation

struct User : Decodable {
    let uid: String
    let username: String
    let profileImageUrl: String
    let firstname: String?
    let lastname: String?
    let isFollowing: Bool
}
