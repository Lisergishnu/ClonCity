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
    var offscreenLayer : CGLayer?
    var layerContext : CGContext?
    var mapviewBounds : NSRect?
    var tileSize : Int = 32
    var mapWidth : Int = 0
    var mapHeight : Int = 0
    
    override var fittingSize : NSSize {
        get {
            return NSSize(width: mapWidth, height: mapHeight)
        }
    }
    
    func initializeBackgroundRenderingLayer(initialMap: CCMapModel) {
        currentMap = initialMap
        /* Define dynamic boundaries for total layer size */
        mapWidth = currentMap!.width*tileSize
        mapHeight = currentMap!.height*tileSize
        mapviewBounds = NSRect(x: 0, y: 0,
            width: mapWidth, height: mapHeight)
        self.setFrameSize(fittingSize)
        
        let context = NSGraphicsContext.currentContext()!.CGContext
        offscreenLayer = CGLayerCreateWithContext(context,
            CGSize(width: mapWidth,height: mapHeight), nil)
        layerContext = CGLayerGetContext(offscreenLayer)
        self.wantsLayer = true
        updateCurrentMap(initialMap)
    }
    
    func updateCurrentMap(updatedMap: CCMapModel) {
        currentMap = updatedMap
        for var i = 0; i < currentMap?.width; i++ {
            for var j = 0; j < currentMap?.height; j++ {
                var type = currentMap!.terrain![i][j]
                if i % 2 == 0 && j % 2 == 0 || i % 2 != 0 && j % 2 != 0 {
                    CGContextSetRGBFillColor(layerContext, 0, 1, 0, 1)
                } else {
                    CGContextSetRGBFillColor(layerContext, 1, 0, 0, 1)
                }
                CGContextFillRect(layerContext, NSRect(x: i*tileSize,
                    y: j*tileSize, width: tileSize,height: tileSize))
            }
        }
        self.layout()
        self.needsDisplay = true
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        if currentMap == nil {
            return
        }
        
        let context = NSGraphicsContext.currentContext()!.CGContext
        CGContextDrawLayerInRect(context, mapviewBounds!, offscreenLayer)
    }
}
