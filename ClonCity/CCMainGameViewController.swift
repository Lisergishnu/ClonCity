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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("Created game view")
    }
    
    func prepareInterfaceForMapEditing() {
        toolsPanel.orderFrontRegardless()
        terraformingPanel.orderFrontRegardless()
        minimap.orderFrontRegardless()
        mainWindow.makeKeyAndOrderFront(nil)
        
    }
    
}
