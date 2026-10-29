import CoreGraphics
import Foundation

// Usage: keystroke "<mod>+<mod>:<keycode>", e.g. "option+shift:0" (Vorssaint's shortcut format).
let parts = CommandLine.arguments.dropFirst().first?.split(separator: ":") ?? []
guard parts.count == 2, let keyCode = CGKeyCode(parts[1]) else {
    print("usage: keystroke <mod>+<mod>:<keycode>")
    exit(1)
}

let modifierKeys: [Substring: (CGKeyCode, CGEventFlags)] = [
    "command": (55, .maskCommand),
    "shift": (56, .maskShift),
    "option": (58, .maskAlternate),
    "control": (59, .maskControl),
]
let modifiers = parts[0].split(separator: "+").compactMap { modifierKeys[$0] }

// Hotkey apps often check the real modifier key state, so press the modifiers
// themselves rather than only flagging the key event.
let source = CGEventSource(stateID: .hidSystemState)
var flags: CGEventFlags = []

func post(_ key: CGKeyCode, down: Bool) {
    let event = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: down)
    event?.flags = flags
    event?.post(tap: .cghidEventTap)
    usleep(10_000)
}

for (key, flag) in modifiers {
    flags.insert(flag)
    post(key, down: true)
}
post(keyCode, down: true)
post(keyCode, down: false)
for (key, flag) in modifiers.reversed() {
    flags.remove(flag)
    post(key, down: false)
}
