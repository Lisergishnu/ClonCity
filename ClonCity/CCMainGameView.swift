//
//  CCMainGameView.swift
//  ClonCity
//
//  Created by Marco Benzi Tobar on 19-08-15.
//  Copyright (c) 2015 Marco Benzi Tobar. All rights reserved.
//

import Cocoa

class CCMainGameView: NSView {
    
    var currentMap : CCMapModel?
    
    func updateCurrentMap(updatedMap: CCMapModel) {
        currentMap = updatedMap
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        for var i = 0; i < currentMap?.width; i++ {
            for var j = 0; j < currentMap?.height; j++ {
                var type = currentMap!.terrain![i][j]
                switch type  {
                default:
                    NSColor.blackColor().setFill()
                }
                let path = NSBezierPath(rect:
                    NSRect(x: i*16, y: j*16, width: 16,height: 16))
                path.fill()
            }
        }
        
    }
    
}
