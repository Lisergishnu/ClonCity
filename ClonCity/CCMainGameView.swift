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
    var currentSelectedTool : CCMainGameViewController.CCMapManipulationTool?
    
    override func acceptsFirstMouse(theEvent: NSEvent) -> Bool {
        return Bool(true)
    }
    
    override var fittingSize : NSSize {
        get {
            return NSSize(width: mapWidth, height: mapHeight)
        }
    }
    
    func setCurrentSelectedTool(tool: CCMainGameViewController.CCMapManipulationTool?) {
        currentSelectedTool = tool
        self.needsDisplay = true
        self.window!.invalidateCursorRectsForView(self)
        self.window!.makeKeyWindow()
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
        drawCurrentMap(initialMap)
    }
    
    override func resetCursorRects() {
        if (currentSelectedTool != nil) {
            
            var toDraw : NSImage?
            switch currentSelectedTool! {
            case CCMainGameViewController.CCMapManipulationTool.CCTERRAIN_WATER:
                toDraw = waterImage
            case CCMainGameViewController.CCMapManipulationTool.CCTERRAIN_TREES:
                toDraw = treesImage
            case CCMainGameViewController.CCMapManipulationTool.CCTERRAIN_DIRT:
                toDraw = dirtImage
            default:
                break
            }
            
            let cur = NSCursor(image: toDraw!, hotSpot: NSPoint(x: 0,y: 0))
            self.addCursorRect(self.bounds, cursor: cur)
        } else {
            self.addCursorRect(self.bounds, cursor: NSCursor.arrowCursor())
        }
    }
    
    func drawCurrentMap(updatedMap: CCMapModel) {
        currentMap = updatedMap
        for var i = 0; i < currentMap?.width; i++ {
            for var j = 0; j < currentMap?.height; j++ {
                var type = currentMap!.terrain![i][j]
                drawTerrainTileAtTileCoordinate(i, y: j, type: type)
            }
        }
        self.layout()
        self.needsDisplay = true
    }
    
    func drawTerrainTileAtTileCoordinate(x: Int, y: Int,
        type: CCMapModel.CCTerrainType) {
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
            CGContextDrawImage(layerContext, NSRect(x: x*tileSize,
                y: y*tileSize, width: tileSize,height: tileSize), toDraw)
        
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        if currentMap == nil {
            return
        }
        
        let context = NSGraphicsContext.currentContext()!.CGContext
        CGContextDrawLayerInRect(context, mapviewBounds!, offscreenLayer)
        
        if (currentSelectedTool != nil) {
            
            var ml = self.window!.mouseLocationOutsideOfEventStream
            ml = self.convertPoint(ml, fromView: nil)
            NSLog("Mouse moved at (%f, %f)", ml.x, ml.y)
            
             var toDraw : NSImage?
            switch currentSelectedTool! {
            case CCMainGameViewController.CCMapManipulationTool.CCTERRAIN_WATER:
                toDraw = waterImage
            case CCMainGameViewController.CCMapManipulationTool.CCTERRAIN_TREES:
                toDraw = treesImage
            case CCMainGameViewController.CCMapManipulationTool.CCTERRAIN_DIRT:
                toDraw = dirtImage
            default:
                break
            }
            
            let d = toDraw?.CGImage
            CGContextDrawImage(context, NSRect(x: ml.x,
                y: ml.y, width: CGFloat(tileSize),height: CGFloat(tileSize)), d)
        }
    }
}
