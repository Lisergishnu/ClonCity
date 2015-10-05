//
//  CCMinimapGameView.swift
//  ClonCity
//
//  Created by Marco Benzi Tobar on 19-08-15.
//  Copyright (c) 2015 Marco Benzi Tobar. All rights reserved.
//

import Cocoa

class CCMinimapGameView: NSView {
    
    var currentMap : CCMapModel?
    let miniTileSize : Int = 2
    var offscreenLayer : CGLayer?
    var layerContext : CGContext?
    var minimapSize : CGSize?
    
    func initializeMinimapView(map: CCMapModel) {
        if offscreenLayer == nil {
            minimapSize = CGSize(width: map.width * miniTileSize,
                height: map.height * miniTileSize)
            self.frame = NSRect(origin: CGPoint(x: 0,y: 0), size: minimapSize!)
            
            let context = NSGraphicsContext.currentContext()!.CGContext
            offscreenLayer = CGLayerCreateWithContext(context,
                minimapSize!, nil)
            layerContext = CGLayerGetContext(offscreenLayer)
            self.wantsLayer = true
        }
        updateCurrentMap(map)
    }
    
    func updateCurrentMap(map: CCMapModel) {
        currentMap = map
        
        for var i = 0; i < currentMap?.width; i++ {
            for var j = 0; j < currentMap?.height; j++ {
                let type = currentMap!.terrain![i][j]
                switch type {
                case .CCTERRAIN_WATER:
                    CGContextSetRGBFillColor(layerContext, 0, 0, 1, 1)
                case .CCTERRAIN_TREE:
                    CGContextSetRGBFillColor(layerContext, 0, 1, 0, 1)
                case .CCTERRAIN_DIRT:
                    CGContextSetRGBFillColor(layerContext, 152/255, 102/255, 51/255, 1)
                default:
                    CGContextSetRGBFillColor(layerContext, 152/255, 102/255, 51/255, 1)
                }
                CGContextFillRect(layerContext, CGRect(x: i * miniTileSize,
                    y: j * miniTileSize,
                    width: miniTileSize,
                    height: miniTileSize))
            }
        }
        self.needsDisplay = true
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        if currentMap == nil {
            return
        }
        
        let context = NSGraphicsContext.currentContext()!.CGContext
        CGContextDrawLayerAtPoint(context, CGPoint(x: 0,y: 0), offscreenLayer!)
    }
    
}
