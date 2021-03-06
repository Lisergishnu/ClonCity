//
//  CCMainGameViewController.swift
//  ClonCity
//
//  Created by Marco Benzi Tobar on 19-08-15.
//  Copyright (c) 2015 Marco Benzi Tobar. All rights reserved.
//

import Cocoa

class CCMainGameViewController: NSViewController {
    
    @IBOutlet weak var toolsPanel: NSPanel!
    @IBOutlet weak var mainWindow: NSWindow!
    @IBOutlet weak var terraformingPanel: NSPanel!
    @IBOutlet weak var minimapViewController : CCMinimapViewController!
    @IBOutlet weak var preparingMapModalViewController: NSViewController!
    @IBOutlet weak var preparingMapModalViewProgressBar: NSProgressIndicator!
    
    enum CCMapManipulationTool {
        case CCTERRAIN_DIRT
        case CCTERRAIN_WATER
        case CCTERRAIN_TREES
        case CCBUILDING_RESIDENTIAL
        case CCBUILDING_COMERCIAL
        case CCBUILDING_INDUSTRIAL
        case CCBUILDING_POWERLINE
        case CCBUILDING_POWERPLANT
        case CCBUILDING_ROAD
    }
    
    var isEditingMap : Bool = false
    var mapUnderEdit : CCMapModel?
    var currentToolSelected : CCMainGameViewController.CCMapManipulationTool?
    var mapEdited : Bool = false
    
    @IBAction func selectDirtForTerrainEditing(sender: AnyObject?) {
        if (isEditingMap) {
            currentToolSelected = CCMapManipulationTool.CCTERRAIN_DIRT
        }
        else
        {
            NSLog("Warning: Selected terrain for editing outside of edit mode.")
        }
        
        updateView()
    }
    
    @IBAction func selectWaterForTerrainEditing(sender: AnyObject?) {
        if (isEditingMap) {
            currentToolSelected = CCMapManipulationTool.CCTERRAIN_WATER
        }
        else
        {
            NSLog("Warning: Selected terrain for editing outside of edit mode.")
        }
        
        updateView()
    }
    
    @IBAction func selectTreesForTerrainEditing(sender: AnyObject?) {
        if (isEditingMap) {
            currentToolSelected = CCMapManipulationTool.CCTERRAIN_TREES
        }
        else
        {
            NSLog("Warning: Selected terrain for editing outside of edit mode.")
        }
        
        updateView()
    }
    
    @IBAction func deselectMapManipulationTool(sender: AnyObject?) {
        currentToolSelected = nil
        
        updateView()
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        var point = theEvent.locationInWindow
        point = view.convertPoint(point, fromView: nil)
        NSLog("Mouse dragged at (%f, %f)", point.x, point.y)
        
        editMapAtPoint(point)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        var point = theEvent.locationInWindow
        point = view.convertPoint(point, fromView: nil)
        NSLog("Mouse down at (%f, %f)", point.x, point.y)
        
        editMapAtPoint(point)
    }
    
    func editMapAtPoint(point: NSPoint) {

        
        if currentToolSelected != nil {
            let v = view as! CCMainGameView
            let i : Int = Int((point.x + 16) / CGFloat(v.tileSize))
            let j : Int = Int((point.y - 16) / CGFloat(v.tileSize))
            
            var t : CCMapModel.CCTerrainType = CCMapModel.CCTerrainType.CCTERRAIN_DIRT
            switch currentToolSelected! {
            case .CCTERRAIN_DIRT:
                t = CCMapModel.CCTerrainType.CCTERRAIN_DIRT
            case .CCTERRAIN_WATER:
                t = CCMapModel.CCTerrainType.CCTERRAIN_WATER
            case .CCTERRAIN_TREES:
                t = CCMapModel.CCTerrainType.CCTERRAIN_TREE
            default:
                break
            }
            
            mapUnderEdit!.terrain![i][j] = t
            v.drawTerrainTileAtTileCoordinate(i, y: j, type: t)
            mapEdited = true
            mainWindow.documentEdited = true
            v.needsDisplay = true
            minimapViewController.updateMinimap(mapUnderEdit!)
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("Created game view")
    }
    
    func updateView() {
        let v = view as! CCMainGameView
        v.setCurrentSelectedTool(currentToolSelected)
    }
    
    func prepareInterfaceForMapEditing(map: CCMapModel) {
        toolsPanel.orderFrontRegardless()
        terraformingPanel.orderFrontRegardless()
        mainWindow.makeKeyAndOrderFront(nil)
        mainWindow.title = "Nuevo Mapa"
        mainWindow.makeMainWindow()
        
        self.presentViewControllerAsSheet(preparingMapModalViewController)
        preparingMapModalViewProgressBar.usesThreadedAnimation = true
        preparingMapModalViewProgressBar.bezeled = true
        preparingMapModalViewProgressBar.startAnimation(self)
        
        isEditingMap = true
        mapUnderEdit = map
        let mapview = view as! CCMainGameView
        mapview.initializeBackgroundRenderingLayer(mapUnderEdit!)
        minimapViewController.showMinimap(mapUnderEdit!)
        
        preparingMapModalViewProgressBar.stopAnimation(self)
        self.dismissViewController(preparingMapModalViewController)
    }
}
