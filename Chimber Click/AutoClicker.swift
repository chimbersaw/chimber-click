//
//  AutoClicker.swift
//  Chimber Click
//
//  Created by Maxim on 01.04.2023.
//

import Cocoa
import CoreGraphics

class AutoClicker {
    private var timer: DispatchSourceTimer?
    private var backgroundTask: NSObjectProtocol?

    func start(interval: TimeInterval) {
        beginBackgroundTask()
        
        let timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: .now(), repeating: interval)
        timer.setEventHandler { [weak self] in
            self?.performAutoclick()
        }
        timer.resume()
        self.timer = timer
    }

    func stop() {
        timer?.cancel()
        timer = nil
        endBackgroundTask()
    }
    
    private func beginBackgroundTask() {
        backgroundTask = ProcessInfo.processInfo.beginActivity(options: [.userInitiatedAllowingIdleSystemSleep], reason: "AutoClicker background task")
    }

    private func endBackgroundTask() {
        if let backgroundTask = backgroundTask {
            ProcessInfo.processInfo.endActivity(backgroundTask)
            self.backgroundTask = nil
        }
    }

    private func performAutoclick() {
        let mouseLocation = NSEvent.mouseLocation
        let screenHeight = NSScreen.main?.frame.height ?? 0
        let flippedMouseLocation = CGPoint(x: mouseLocation.x, y: screenHeight - mouseLocation.y)
        let mouseEvent = CGEvent(mouseEventSource: nil, mouseType: .leftMouseDown, mouseCursorPosition: flippedMouseLocation, mouseButton: .left)
        let mouseReleaseEvent = CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp, mouseCursorPosition: flippedMouseLocation, mouseButton: .left)

        mouseEvent?.post(tap: .cghidEventTap)
        mouseReleaseEvent?.post(tap: .cghidEventTap)
    }
}
