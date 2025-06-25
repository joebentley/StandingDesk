//
//  main.swift
//  Standing Desk
//
//  Created by Joe Bentley on 25.06.25.
//

import AppKit

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
