//
//  CCMainGameView.swift
//  ClonCity
//
//  Created by Marco Benzi Tobar on 19-08-15.
//  Copyright (c) 2015 Marco Benzi Tobar. All rights reserved.
//

import Cocoa

class CCMainGameView: NSView {
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        NSColor.blueColor().setFill()
        
        let path = NSBezierPath(rect: self.bounds)
        
        path.fill()
        NSLog("Calling drawRect...\n")
    }
    
}
