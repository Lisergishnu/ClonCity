//
//  CCMapModel.swift
//  ClonCity
//
//  Created by Marco Benzi Tobar on 20-08-15.
//  Copyright (c) 2015 Marco Benzi Tobar. All rights reserved.
//

import Foundation

class CCMapModel {
    
    enum CCTerrainType {
        case CCTERRAIN_WATER
        case CCTERRAIN_DIRT
        case CCTERRAIN_GRASS
        case CCTERRAIN_TREE
    }
    
    var terrain : [[CCTerrainType]]?;
    
    func createEmptyModel(width: Int, height: Int, defaultTerrain:CCTerrainType) {
        terrain = Array(count:width,
            repeatedValue:Array(count:height, repeatedValue:defaultTerrain))
    }
}