//
//  AppDelegate.swift
//  Standing Desk
//
//  Created by Joe Bentley on 25.06.25.
//

// Status bar app created using this tutorial https://sarunw.com/posts/how-to-make-macos-menu-bar-app/

import Cocoa
import UserNotifications

let setupNotificationIdentifier = "com.joebentley.setupstandnotification"
let repeatingNotificationIdentifier = "com.joebentley.standnotification"

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var notificationCenter: UNUserNotificationCenter!
    
    private var startButton: NSMenuItem!
    private var stopButton: NSMenuItem!

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(
            withLength: NSStatusItem.variableLength
        )
        if let button = statusItem.button {
            button.image = NSImage(
                systemSymbolName: "alarm.fill",
                accessibilityDescription: "alarm"
            )
        }

        notificationCenter = UNUserNotificationCenter.current()
        Task {
            do {
                let granted = try await notificationCenter.requestAuthorization(
                    options: [.alert, .badge])
                if granted {
                    // Cancel the in-flight notification
                    _cancel_repeating_notification()
                } else {
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
    
    func applicationWillTerminate(_ notification: Notification) {
        _cancel_repeating_notification()
    }

    func setupMenus() {
        let menu = NSMenu()
        menu.autoenablesItems = false
        
        startButton = NSMenuItem(
            title: "Start timer",
            action: #selector(didClickStart),
            keyEquivalent: "t"
        )
        menu.addItem(startButton)
        
        stopButton = NSMenuItem(
            title: "Stop timer",
            action: #selector(didClickStop),
            keyEquivalent: "s"
        )
        stopButton.isEnabled = false
        menu.addItem(stopButton)
        
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
    
    func _cancel_repeating_notification() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [repeatingNotificationIdentifier])
    }
    
    func _post_start_notification() {
        let content = UNMutableNotificationContent()
        content.title = "Notification setup"
        content.body = "You will be notified every 30 minutes"
        
        let notification = UNNotificationRequest(
            identifier: setupNotificationIdentifier,
            content: content,
            trigger: nil
        )
        notificationCenter.add(notification)
    }
    
    func _post_repeating_notification() {
        let content = UNMutableNotificationContent()
        content.title = "Stand reminder"
        content.body = "Don't forget to stand!"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (30*60), repeats: true)
        
        let notification = UNNotificationRequest(
            identifier: repeatingNotificationIdentifier,
            content: content,
            trigger: trigger
        )
        notificationCenter.add(notification)
    }

    @objc func didClickStart() {
        _post_start_notification()
        _post_repeating_notification()
        
        startButton.isEnabled = false
        stopButton.isEnabled = true
    }
    
    @objc func didClickStop() {
        _cancel_repeating_notification()
        startButton.isEnabled = true
        stopButton.isEnabled = false
    }
}
