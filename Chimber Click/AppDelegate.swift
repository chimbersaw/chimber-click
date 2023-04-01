//
//  AppDelegate.swift
//  Chimber Click
//
//  Created by Maxim on 01.04.2023.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        ProcessInfo.processInfo.disableAutomaticTermination("User disabled App Nap")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        ProcessInfo.processInfo.enableAutomaticTermination("User enabled App Nap")
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

