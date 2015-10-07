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
    var gameRunning : Bool = false
    
    func getDefaultMapFolder() -> NSURL? {
        let fm = NSFileManager.defaultManager()
        let bundleID = NSBundle.mainBundle().bundleIdentifier
        let appsupport = fm.URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)
        if appsupport.count > 0 {
            let dirPath = appsupport[0].URLByAppendingPathComponent(bundleID!).URLByAppendingPathComponent("Terrain Maps")
            
            do {
                try fm.createDirectoryAtURL(dirPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("Couldn't initialize path at %s", dirPath)
                return nil
            }
            return dirPath
        } else  {
            return nil
        }
    }
    
    func getDefaultSavegameFolder() -> NSURL? {
        let fm = NSFileManager.defaultManager()
        let bundleID = NSBundle.mainBundle().bundleIdentifier
        let appsupport = fm.URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)
        if appsupport.count > 0 {
            let dirPath = appsupport[0].URLByAppendingPathComponent(bundleID!).URLByAppendingPathComponent("Saved Games")
            
            do {
                try fm.createDirectoryAtURL(dirPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("Couldn't initialize path at %s", dirPath)
                return nil
            }
            return dirPath
        } else  {
            return nil
        }
    }
    
    
    @IBAction func createNewMap(sender: AnyObject?) {
        splashWindow.orderOut(sender)
        mapUnderEdit = CCMapModel()
        mapUnderEdit!.createEmptyModel(100, height: 100, defaultTerrain: CCMapModel.CCTerrainType.CCTERRAIN_WATER)
        mainGameViewController.prepareInterfaceForMapEditing(mapUnderEdit!)
    }
    
    @IBAction func loadEditableTerrain(sender: AnyObject?) {
        // Check if theres currently a game or a map being edited
        if (gameRunning) {
            let gameNotSaved : NSAlert = NSAlert()
            gameNotSaved.addButtonWithTitle("Guardar Juego")
            gameNotSaved.addButtonWithTitle("No Guardar")
            gameNotSaved.addButtonWithTitle("Cancelar")
            gameNotSaved.messageText = "Juego no guardado"
            gameNotSaved.informativeText = "Cargar un mapa hará perder el progreso actual del juego. ¿Desea guardar antes de continuar?"
            gameNotSaved.alertStyle = NSAlertStyle.WarningAlertStyle
            
            let r  = gameNotSaved.runModal()
            
            if r == NSAlertFirstButtonReturn {
                // Save game
            } else if r == NSAlertSecondButtonReturn {
                // Continue without saving
            } else {
                // Do nothing
                return
            }
        } else if (mapUnderEdit != nil && mainMapWindow.documentEdited) {
            let gameNotSaved : NSAlert = NSAlert()
            gameNotSaved.addButtonWithTitle("Guardar Mapa")
            gameNotSaved.addButtonWithTitle("No Guardar")
            gameNotSaved.addButtonWithTitle("Cancelar")
            gameNotSaved.messageText = "Mapa no guardado"
            gameNotSaved.informativeText = "Cargar un mapa hará perder los cambios no guardados en el que está siendo editado actualmente. ¿Desea guardar antes de continuar?"
            gameNotSaved.alertStyle = NSAlertStyle.WarningAlertStyle
            let r = gameNotSaved.runModal()
            if r == NSAlertFirstButtonReturn {
                // Save map
                self.save(sender)
                openMapLoadDialog(sender)
            } else if r == NSAlertSecondButtonReturn {
                // Continue without saving
                openMapLoadDialog(sender)
            } else {
                // Do nothing
                return
            }
        } else {
            openMapLoadDialog(sender)
        }
    }
    
    func openMapLoadDialog(sender: AnyObject?) {
        let openDialog : NSOpenPanel = NSOpenPanel()
        
        openDialog.title = "Abrir mapa para editar"
        openDialog.allowedFileTypes = ["ccmap"]
        openDialog.directoryURL = getDefaultMapFolder()
        let r = openDialog.runModal()
        if r == NSFileHandlingPanelOKButton {
            splashWindow.orderOut(sender)
            mapUnderEdit = self.deserializeMap(openDialog.URL!)
            mainGameViewController.prepareInterfaceForMapEditing(mapUnderEdit!)
            mainMapWindow.setTitleWithRepresentedFilename(openDialog.URL!.path!)
            mainMapWindow.representedURL = openDialog.URL!
        } else {
            return
        }
        
    }
    
    func deserializeMap(mapPath : NSURL) -> CCMapModel? {
        let checkLoad = NSData(contentsOfURL: mapPath)
        var error : NSError?
        let map = CCMapModel(data: checkLoad!, error: &error)
        if (error != nil) {
            mainMapWindow.presentError(error!)
            return nil
        }
        return map
    }
    
    @IBAction func save(sender: AnyObject?) {
        if (mapUnderEdit != nil) {
            let fpath = mainMapWindow.representedURL
            if fpath != nil {
                let data = self.mapUnderEdit!.data
                if data.writeToURL(fpath!, atomically: false) {
                    mainMapWindow.documentEdited = false
                }
            } else {
                saveMapDialog(sender)
            }
        }
    }
    
    @IBAction func saveAs(sender: AnyObject?) {
        if (mapUnderEdit != nil) {
            saveMapDialog(sender)
        }
    }
    
    func saveMapDialog(sender: AnyObject?) {
        let saveDialog : NSSavePanel = NSSavePanel();
        var fpath : NSURL?
        
        saveDialog.title = "Guardar mapa"
        saveDialog.allowedFileTypes = ["ccmap"]
        saveDialog.directoryURL = getDefaultMapFolder()
        let r = saveDialog.runModal()
        if (r == NSFileHandlingPanelOKButton) {
            fpath = saveDialog.URL!
            let data = self.mapUnderEdit!.data
            data.writeToURL(fpath!, atomically: false)
            self.mainMapWindow.setTitleWithRepresentedFilename(fpath!.path!)
            self.mainMapWindow.documentEdited = false
            self.mainGameViewController.mapEdited = false
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

