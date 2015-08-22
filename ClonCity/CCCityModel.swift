//
//  CCCityModel.swift
//  ClonCity
//
//  Created by Marco Benzi Tobar on 20-08-15.
//  Copyright (c) 2015 Marco Benzi Tobar. All rights reserved.
//

import Foundation

enum CCDifficultyLevel {
    case CCDIFFICULTY_EASY
    case CCDIFFICULTY_MEDIUM
    case CCDIFFICULTY_HARD
}

class CCCityModel {
    
    var population : Int = 0
    var money : Int = 0
    var year : Int = 1900
    var cityName : String = "Ciudad por defecto"
    var mayorName : String = "Nombre por defecto"
    var difficulty : CCDifficultyLevel = CCDifficultyLevel.CCDIFFICULTY_EASY
    
    var map : CCMapModel?
    
    init(initMoney: Int, initYear: Int, map: CCMapModel, cityName: String?, mayorName: String?) {
        initializeCity(initMoney, initYear: initYear, map: map, cityName: cityName, mayorName: mayorName)
    }
    
    func initializeCity(initMoney: Int,
        initYear: Int, map: CCMapModel,
        cityName: String?, mayorName: String?) {
            population = 0
            money = initMoney
            year = initYear
            self.map = map
            self.cityName = cityName!
            self.mayorName = mayorName!
    }
    
}