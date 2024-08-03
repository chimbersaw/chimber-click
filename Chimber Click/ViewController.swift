//
//  ViewController.swift
//  chimber-click
//
//  Created by Maxim on 01.04.2023.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var intervalTextField: NSTextField!
    @IBOutlet weak var button: NSButtonCell!
    @IBOutlet weak var isRightClick: NSButton!
    
    var autoClicker = AutoClicker()
    var isAutoClickerRunning = false
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        view.window?.title = "Chimber Clicker"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event -> NSEvent? in
            self?.handleKeyDownEvent(event)
            return event
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyDownEvent(event)
        }
    }

    func handleKeyDownEvent(_ event: NSEvent) {
        if event.keyCode == 42 {
            toggleAutoClicker()
        }
    }

    override func mouseDown(with event: NSEvent) {
        view.window?.makeFirstResponder(nil)
    }
    
    @IBAction func pressButton(_ sender: Any) {
        view.window?.makeFirstResponder(nil)
        toggleAutoClicker()
    }
    
    func toggleAutoClicker() {
        if isAutoClickerRunning {
            stopAutoClicker()
        } else {
            startAutoClicker()
        }
    }
    
    func startAutoClicker() {
        if var interval = Double(intervalTextField.stringValue), interval >= 0.0 {
            button.title = "Stop Auto-Clicker"
            interval = max(0.001, interval)
            
            autoClicker.start(interval: interval, isRightClick: isRightClick.state == .on)

            isAutoClickerRunning = true
        }
    }
    
    func stopAutoClicker() {
        button.title = "Start Auto-Clicker"
        autoClicker.stop()
        isAutoClickerRunning = false
    }
}

