//
//  CCMinimapViewController.swift
//  ClonCity
//
//  Created by Marco Benzi Tobar on 28-08-15.
//  Copyright (c) 2015 Marco Benzi Tobar. All rights reserved.
//

import Cocoa

class CCMinimapViewController: NSViewController {

    @IBOutlet weak var minimapPanel : NSPanel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showMinimap(map: CCMapModel) {
        
        let a = view as! CCMinimapGameView
        minimapPanel.setFrame(NSRect(x: 819, y: 207,
            width: map.width*a.miniTileSize,
            height: map.height*a.miniTileSize),
            display: false,
            animate: true)
        a.initializeMinimapView(map)
        minimapPanel.orderFrontRegardless()
    }
    
    func updateMinimap(map: CCMapModel) {
        let a = view as! CCMinimapGameView
        a.updateCurrentMap(map)
    }
    
}
