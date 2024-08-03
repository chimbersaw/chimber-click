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

    func start(interval: TimeInterval, isRightClick: Bool) {
        beginBackgroundTask()
        
        let timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: .now(), repeating: interval)
        timer.setEventHandler { [weak self] in
            self?.performAutoclick(isRightClick: isRightClick)
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
        backgroundTask = ProcessInfo.processInfo.beginActivity(
            options: [.userInitiatedAllowingIdleSystemSleep],
            reason: "AutoClicker background task"
        )
    }

    private func endBackgroundTask() {
        if let task = backgroundTask {
            ProcessInfo.processInfo.endActivity(task)
            self.backgroundTask = nil
        }
    }

    private func performAutoclick(isRightClick: Bool) {
        let mouseLocation = NSEvent.mouseLocation
        let screenHeight = NSScreen.main?.frame.height ?? 0
        let flippedMouseLocation = CGPoint(x: mouseLocation.x, y: screenHeight - mouseLocation.y)

        let mouseDownType: CGEventType = isRightClick ? .rightMouseDown : .leftMouseDown
        let mouseUpType: CGEventType = isRightClick ? .rightMouseUp : .leftMouseUp
        let mouseButton: CGMouseButton = isRightClick ? .right : .left

        let mouseEvent = CGEvent(
            mouseEventSource: nil,
            mouseType: mouseDownType,
            mouseCursorPosition: flippedMouseLocation,
            mouseButton: mouseButton
        )
        let mouseReleaseEvent = CGEvent(
            mouseEventSource: nil,
            mouseType: mouseUpType,
            mouseCursorPosition: flippedMouseLocation,
            mouseButton: mouseButton
        )

        mouseEvent?.post(tap: .cghidEventTap)
        mouseReleaseEvent?.post(tap: .cghidEventTap)
    }
}
