//
//  CCMainGameView.swift
//  ClonCity
//
//  Created by Marco Benzi Tobar on 19-08-15.
//  Copyright (c) 2015 Marco Benzi Tobar. All rights reserved.
//

import Cocoa

extension NSImage {
    var CGImage: CGImageRef {
        get {
            let imageData = self.TIFFRepresentation
            let source = CGImageSourceCreateWithData(imageData as! CFDataRef, nil)
            let maskRef = CGImageSourceCreateImageAtIndex(source, Int(0), nil)
            return maskRef;
        }
    }
}

class CCMainGameView: NSView {
    
    var currentMap : CCMapModel?
    var offscreenLayer : CGLayer?
    var layerContext : CGContext?
    var mapviewBounds : NSRect?
    var tileSize : Int = 32
    var mapWidth : Int = 0
    var mapHeight : Int = 0
    var dirtImage : NSImage? = NSImage(named: "Dirt")
    var waterImage : NSImage? = NSImage(named: "Water")
    var treesImage : NSImage? = NSImage(named: "Trees")
    
    
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
                var tileToDraw : NSImage?
                switch type {
                case .CCTERRAIN_WATER:
                    tileToDraw = waterImage
                case .CCTERRAIN_TREE:
                    tileToDraw = treesImage
                case .CCTERRAIN_DIRT:
                    tileToDraw = dirtImage
                default:
                    tileToDraw = dirtImage
                }
                
                let toDraw = tileToDraw?.CGImage
                CGContextDrawImage(layerContext, NSRect(x: i*tileSize,
                    y: j*tileSize, width: tileSize,height: tileSize), toDraw)
                
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
