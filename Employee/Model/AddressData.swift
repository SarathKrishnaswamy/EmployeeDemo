//
//  AddressData.swift
//  Employee
//
//  Created by Sarath Krishnaswamy on 25/06/22.
//

import Foundation
struct AddressData : Codable {
    let street : String?
    let suite : String?
    let city : String?
    let zipcode : String?
    let geo : GeoData?

    enum CodingKeys: String, CodingKey {

        case street = "street"
        case suite = "suite"
        case city = "city"
        case zipcode = "zipcode"
        case geo = "geo"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        street = try values.decodeIfPresent(String.self, forKey: .street)
        suite = try values.decodeIfPresent(String.self, forKey: .suite)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        zipcode = try values.decodeIfPresent(String.self, forKey: .zipcode)
        geo = try values.decodeIfPresent(GeoData.self, forKey: .geo)
    }

}
