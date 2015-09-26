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
    @IBOutlet weak var mainMapWindow: NSWindow!
    
    var mapUnderEdit : CCMapModel?
    
    @IBAction func createNewMap(sender: AnyObject?) {
        splashWindow.orderOut(sender)
    
        mapUnderEdit = mainGameViewController.prepareInterfaceForMapEditing()
        windowMenu.hidden = false
        terraformWindowMenuItem.hidden = false
        newMapMenuItem.hidden = true
    }
    
    func loadMapForEdit(map :CCMapModel) {
        
    }
    
    @IBAction func saveMap(sender: AnyObject?) {
        if (mapUnderEdit != nil) {
            let saveDialog : NSSavePanel = NSSavePanel();
            var fpath : NSURL?
            
            saveDialog.title = "Guardar mapa"
            saveDialog.beginSheetModalForWindow(mainMapWindow, completionHandler: {
                if ($0 == NSFileHandlingPanelOKButton) {
                    fpath = saveDialog.URL!
                    let data = self.mapUnderEdit!.data
                    data.writeToURL(fpath!, atomically: false)
                    
                    let checkLoad = NSData(contentsOfURL: fpath!)
                    self.loadMapForEdit(CCMapModel(data: checkLoad!))
                }
            })
            
        }
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

