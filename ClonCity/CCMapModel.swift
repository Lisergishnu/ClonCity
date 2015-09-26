//
//  CCMapModel.swift
//  ClonCity
//
//  Created by Marco Benzi Tobar on 20-08-15.
//  Copyright (c) 2015 Marco Benzi Tobar. All rights reserved.
//

import Foundation

class CCMapModel {
    
    enum CCTerrainType : Int {
        case CCTERRAIN_WATER = 0
        case CCTERRAIN_DIRT = 1
        case CCTERRAIN_TREE = 2
    }
    
    var terrain : [[CCTerrainType]]?
    var width : Int = 0
    var height : Int = 0
    
    var data : NSData {
        get {
            var s : String = ""
            s += "Width " + width.description + "\n"
            s += "Height " + height.description + "\n"
            for var i=0; i<width; i++ {
                for var j=0; j<height; j++ {
                    s += terrain![i][j].rawValue.description
                }
            }
            return s.dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
    
    init(){
        
    }
    
    init(data: NSData) {
        let s = String(data: data, encoding: NSUTF8StringEncoding)
        let a1 = s?.characters.split {$0 == "\n"}
        width = Int( String( (a1![0].split {$0 == " "})[1] ))!
        height = Int( String( (a1![1].split {$0 == " "})[1] ))!
    }
    
    func createEmptyModel(width: Int, height: Int, defaultTerrain:CCTerrainType) {
        terrain = Array(count:width,
            repeatedValue:Array(count:height, repeatedValue:defaultTerrain))
        self.width = width
        self.height = height
        
        terrain![3][3] = CCTerrainType.CCTERRAIN_DIRT
        terrain![3][4] = CCTerrainType.CCTERRAIN_DIRT
        terrain![4][3] = CCTerrainType.CCTERRAIN_DIRT
        
    }
}