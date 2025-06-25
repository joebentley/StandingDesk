//
//  AppDelegate.swift
//  Standing Desk
//
//  Created by Joe Bentley on 25.06.25.
//

// Status bar app created using this tutorial https://sarunw.com/posts/how-to-make-macos-menu-bar-app/

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "1.circle", accessibilityDescription: "1")
        }
        
        setupMenus()
    }
    
    func setupMenus() {
        let menu = NSMenu()
        let test = NSMenuItem(title: "Test", action: #selector(didTapTest), keyEquivalent: "t")
        menu.addItem(test)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }
    
    @objc func didTapTest() {
        let alert = NSAlert()
        alert.messageText = "You clicked test!"
        alert.runModal()
    }
}
