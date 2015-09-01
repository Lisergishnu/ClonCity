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
    @IBOutlet weak var windowMenu: NSMenuItem!
    @IBOutlet weak var terraformWindowMenuItem: NSMenuItem!
    @IBOutlet weak var newMapMenuItem: NSMenuItem!
    
    @IBAction func createNewMap(sender: AnyObject?) {
        splashWindow.orderOut(sender)
        mainGameViewController.prepareInterfaceForMapEditing()
        windowMenu.hidden = false
        terraformWindowMenuItem.hidden = false
        newMapMenuItem.hidden = true
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        splashWindow.makeKeyAndOrderFront(nil)
        windowMenu.hidden = true
        terraformWindowMenuItem.hidden = true
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

