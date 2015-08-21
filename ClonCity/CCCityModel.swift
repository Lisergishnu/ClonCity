//
//  CCCityModel.swift
//  ClonCity
//
//  Created by Marco Benzi Tobar on 20-08-15.
//  Copyright (c) 2015 Marco Benzi Tobar. All rights reserved.
//

import Foundation

class CCCityModel {
    
    var population : Int = 0
    var money : Int = 0
    var year : Int = 1900
    
    var map : CCMapModel?
    
    func initializeCity(initMoney: Int,
        initYear: Int, map: CCMapModel) {
            population = 0
            money = initMoney
            year = initYear
            self.map = map
    }
    
}