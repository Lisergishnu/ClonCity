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
    @IBOutlet weak var preparingMapModalViewController: NSViewController!
    @IBOutlet weak var preparingMapModalViewProgressBar: NSProgressIndicator!
    
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
        
        self.presentViewControllerAsSheet(preparingMapModalViewController)
        preparingMapModalViewProgressBar.usesThreadedAnimation = true
        preparingMapModalViewProgressBar.bezeled = true
        preparingMapModalViewProgressBar.startAnimation(self)
        
        isEditingMap = true
        mapUnderEdit = CCMapModel()
        mapUnderEdit!.createEmptyModel(100, height: 100, defaultTerrain: CCMapModel.CCTerrainType.CCTERRAIN_WATER)
        let mapview = view as! CCMainGameView
        mapview.initializeBackgroundRenderingLayer(mapUnderEdit!)
        
        preparingMapModalViewProgressBar.stopAnimation(self)
        self.dismissViewController(preparingMapModalViewController)
    }
}
