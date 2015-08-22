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
    @IBOutlet weak var minimap: NSPanel!
    @IBOutlet weak var mainScrollView: NSScrollView!
    
    var isEditingMap : Bool = false
    var mapUnderEdit : CCMapModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("Created game view")
    }
    
    func prepareInterfaceForMapEditing() {
        toolsPanel.orderFrontRegardless()
        terraformingPanel.orderFrontRegardless()
        minimap.orderFrontRegardless()
        mainWindow.makeKeyAndOrderFront(nil)
        mainWindow.title = "Nuevo Mapa"
        mainWindow.makeMainWindow()
        
        isEditingMap = true
        mapUnderEdit = CCMapModel()
        mapUnderEdit!.createEmptyModel(10, height: 10, defaultTerrain: CCMapModel.CCTerrainType.CCTERRAIN_WATER)
        let mapview = view as! CCMainGameView
        mapview.updateCurrentMap(mapUnderEdit!)
        mapview.needsDisplay = true
        let clipview = mainScrollView.contentView
        clipview.translatesAutoresizingMaskIntoConstraints = false
        
    }
}
