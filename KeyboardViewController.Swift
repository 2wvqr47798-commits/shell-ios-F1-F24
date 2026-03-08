import UIKit

class KeyboardViewController: UIInputViewController {
    
    @IBOutlet var nextKeyboardButton: UIButton!
    
    // MARK: - macOS Hotkeys Configuration
    let macOSHotkeys: [String: String] = [
        "cmd+c": "Copy",
        "cmd+x": "Cut",
        "cmd+v": "Paste",
        "cmd+z": "Undo",
        "cmd+shift+z": "Redo",
        "cmd+a": "Select All",
        "cmd+s": "Save",
        "cmd+n": "New",
        "cmd+w": "Close",
        "cmd+q": "Quit",
        "cmd+tab": "Switch App",
        "cmd+space": "Spotlight",
        "cmd+,": "Preferences",
        "option+cmd+esc": "Force Quit",
        "shift+cmd+3": "Screenshot",
        "shift+cmd+4": "Screenshot Selection",
        "shift+cmd+5": "Screenshot Options",
    ]
    
    let specialKeys: [String: String] = [
        "⌘": "Command",
        "⌥": "Option/Alt",
        "⇧": "Shift",
        "⌃": "Control",
        "⏎": "Return",
        "⇥": "Tab",
        "⌫": "Delete",
        "↑": "Up Arrow",
        "↓": "Down Arrow",
        "←": "Left Arrow",
        "→": "Right Arrow",
        "⌘⌫": "Delete Word",
    ]
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardLayout()
        setupHotkeys()
    }
    
    // MARK: - Setup Keyboard Layout
    func setupKeyboardLayout() {
        let keyboardView = UIView()
        keyboardView.backgroundColor = UIColor.darkGray
        self.view.addSubview(keyboardView)
        
        // Setup keyboard rows
        let rows = createKeyboardRows()
        layoutKeyboardRows(rows, in: keyboardView)
    }
    
    // MARK: - Create Keyboard Rows
    func createKeyboardRows() -> [[String]] {
        return [
            ["⌘", "⌥", "⇧", "⌃", "Fn", "⏎", "⇥", "⌫"],
            ["⌘+C", "⌘+X", "⌘+V", "⌘+Z", "⌘+A", "⌘+S", "⌘+N"],
            ["↑", "↓", "←", "→", "Home", "End", "PgUp", "PgDn"]
        ]
    }
    
    // MARK: - Layout Keyboard Rows
    func layoutKeyboardRows(_ rows: [[String]], in container: UIView) {
        var yOffset: CGFloat = 10
        
        for row in rows {
            let rowView = createKeyboardRow(keys: row)
            rowView.frame.origin.y = yOffset
            container.addSubview(rowView)
            yOffset += rowView.frame.height + 8
        }
    }
    
    // MARK: - Create Individual Keyboard Row
    func createKeyboardRow(keys: [String]) -> UIView {
        let rowView = UIView()
        let keyWidth = (self.view.frame.width - 20) / CGFloat(keys.count)
        var xOffset: CGFloat = 10
        
        for key in keys {
            let button = createKeyButton(title: key, frame: CGRect(x: xOffset, y: 0, width: keyWidth - 6, height: 44))
            rowView.addSubview(button)
            xOffset += keyWidth
        }
        
        rowView.frame.size.height = 44
        rowView.frame.size.width = self.view.frame.width
        return rowView
    }
    
    // MARK: - Create Individual Key Button
    func createKeyButton(title: String, frame: CGRect) -> UIButton {
        let button = UIButton(frame: frame)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 6
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
        
        return button
    }
    
    // MARK: - Handle Key Press
    @objc func keyPressed(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        
        // Handle hotkey execution
        if let hotkeyAction = macOSHotkeys[title.lowercased()] {
            executeHotkey(title, action: hotkeyAction)
        } else {
            // Insert regular text
            self.textDocumentProxy.insertText(title)
        }
    }
    
    // MARK: - Execute Hotkey Actions
    func executeHotkey(_ key: String, action: String) {
        switch key.lowercased() {
        case "cmd+c":
            UIPasteboard.general.string = (self.textDocumentProxy as? UITextInput)?.selectedText ?? ""
        case "cmd+v":
            if let pastedText = UIPasteboard.general.string {
                self.textDocumentProxy.insertText(pastedText)
            }
        case "cmd+a":
            // Select all in current field
            self.textDocumentProxy.insertText("")
        case "⌫":
            self.textDocumentProxy.deleteBackward()
        case "⇥":
            self.textDocumentProxy.insertText("\t")
        case "⏎":
            self.textDocumentProxy.insertText("\n")
        default:
            self.textDocumentProxy.insertText(key)
        }
    }
    
    // MARK: - Setup Hotkeys
    func setupHotkeys() {
        print("Keyboard initialized with \(macOSHotkeys.count) hotkeys")
        print("Available special keys: \(specialKeys.count)")
    }
    
    // MARK: - Next Keyboard Button
    @IBAction func handleInputModeList(from: UIView!) {
        self.handleInputModeList(from: from, with: UIKeyboardInputMode.activeInputModes())
    }
}