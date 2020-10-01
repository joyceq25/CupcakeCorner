//
//  Order.swift
//  CupcakeCorner
//
//  Created by Ping Yun on 10/1/20.
//

import Foundation

//single class that stores all data, which will be passed from screen to screen
class Order: ObservableObject, Codable {
    //enum that conforms to CodingKey listing all the properties we want to save
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
    }
    
    //static array of all possible options for type of cake
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    //stores type of cakes as index in types
    @Published var type = 0
    //stores number of cakes
    @Published var quantity = 3
    
    //stores whether or not user wants to make special requests, which will show/hide extra options in UI
    @Published var specialRequestEnabled = false {
    //sets extraFrosting and addSprinkles to false if specialRequestEnabled is false
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    //stores whether or not user wants extra frosting
    @Published var extraFrosting = false
    //stores whether or not user wants sprinkles
    @Published var addSprinkles = false
    
    //stores delivery details 
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""
    
    //computed property that checks if name, streetAddress, city, zip properties of order are not empty 
    var hasValidAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        return true
    }
    
    //computed property that calculates cost of order
    var cost: Double {
        //$2 per cake
        var cost = Double(quantity) * 2
        
        //complicated cakes cost more
        cost += (Double(type) / 2)
        
        //add $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        
        //add $0.50/cake for sprinkles
        if addSprinkles {
            cost += (Double(quantity) / 2)
        }
        
        return cost 
    }
    
    //initializer that can create an order without any data for when app starts
    init() {}
    
    //required initializer to decode instance of Order from some archived data 
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        
        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }
    
    //method that creates a container using coding keys enum, then writes out properties attached to their respective key
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)

        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)

        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    }
}
