//
//  AppDelegate.swift
//  ClonCity
//
//  Created by Marco Benzi Tobar on 19-08-15.
//  Copyright (c) 2015 Marco Benzi Tobar. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var splashWindow: NSWindow!
    @IBOutlet weak var mainGameViewController: CCMainGameViewController!
    
    @IBAction func createMapButtonDidGetPressed(sender: NSButton) {
        splashWindow.orderOut(sender)
        mainGameViewController.prepareInterfaceForMapEditing()
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        splashWindow.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

