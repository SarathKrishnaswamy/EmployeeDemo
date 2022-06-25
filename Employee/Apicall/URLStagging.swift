//
//  URLStagging.swift
//  Employee
//
//  Created by Sarath Krishnaswamy on 25/06/22.
//


import Foundation
import UIKit

enum Environment: String {
    case Production   = "http://www.mocky.io/v2"
    case Testing     = "http://www.mocky.io"
    case Development  = ""
}

enum Route: String {
  case api  = "/"
}


extension URL {
    
    // MARK:- 1 getValues api
    static var getValues: String {
        let domain = "\(UserDefaults.standard.object(forKey: Key.UserDefaults.stagingURL) ?? "")"
        let api = domain + Route.api.rawValue
        return api + "5d565297300000680030a986"
    }
    

}
