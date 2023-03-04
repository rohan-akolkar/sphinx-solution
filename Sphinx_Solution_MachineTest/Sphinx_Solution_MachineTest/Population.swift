//
//  Population.swift
//  Sphinx_Solution_MachineTest
//
//  Created by Mac on 04/03/23.
//

import Foundation
struct Population : Decodable{
    let population:[Population]
    enum CodingKeys:CodingKey{
        case population
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.population = try
        container.decode([Population].self,forKey: .population)
    }
    struct Population1:Decodable{
        var Population : Int
        var Year : String
        
        enum populationKey:String,CodingKey{
            case population = "Population"
            case year = "Year"
        }
        init(from decoder: Decoder) throws {
            let container = try
            decoder.container(keyedBy: populationKey.self)
            Population = try container.decode(Int.self, forKey:.population)
            Year = try container.decode(String.self, forKey:.year)
        }
    }
    
    
    

}
