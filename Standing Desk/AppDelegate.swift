//
//  AppDelegate.swift
//  Standing Desk
//
//  Created by Joe Bentley on 25.06.25.
//

// Status bar app created using this tutorial https://sarunw.com/posts/how-to-make-macos-menu-bar-app/

import Cocoa
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var notificationCenter: UNUserNotificationCenter!

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(
            withLength: NSStatusItem.variableLength
        )
        if let button = statusItem.button {
            button.image = NSImage(
                systemSymbolName: "1.circle",
                accessibilityDescription: "1"
            )
        }

        notificationCenter = UNUserNotificationCenter.current()
        Task {
            do {
                let granted = try await notificationCenter.requestAuthorization(
                    options: [.alert, .badge])
                if !granted {
                    let alert = NSAlert()
                    alert.messageText =
                        "This app needs notifications to be useful!"
                }
            } catch {
                let alert = NSAlert(error: error)
                alert.runModal()
            }
        }

        setupMenus()
    }

    func setupMenus() {
        let menu = NSMenu()
        let test = NSMenuItem(
            title: "Test",
            action: #selector(didTapTest),
            keyEquivalent: "t"
        )
        menu.addItem(test)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(
            NSMenuItem(
                title: "Quit",
                action: #selector(NSApplication.terminate(_:)),
                keyEquivalent: "q"
            )
        )
        statusItem.menu = menu
    }

    @objc func didTapTest() {
        let content = UNMutableNotificationContent()
        content.title = "Stand reminder!"
        content.body = "Don't forget to stand!"
        let notification = UNNotificationRequest(
            identifier: "com.joebentley.standnotification",
            content: content,
            trigger: nil
        )
        notificationCenter.add(notification)
    }
}
