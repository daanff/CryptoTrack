//
//  Models.swift
//  CryptoTrack
//
//  Created by daanff on 2021-09-23.
//

import Foundation

struct Crypto: Codable {
    let asset_id: String?
    let name: String?
    let price_usd: Float?
    let id_icon: String?
    
}

struct Icon: Codable {
    let asset_id: String
    let url: String
}
