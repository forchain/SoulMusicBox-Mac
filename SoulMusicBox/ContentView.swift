//
//  ContentView.swift
//  SoulMusicBox
//
//  Created by Tony Outlier on 11/24/24.
//

import SwiftUI
import AppKit

// 添加鼠标控制辅助类
class MouseControl {
    static func moveAndClick(to point: CGPoint, rightClick: Bool = false, doubleClick: Bool = false) {
        // Get element at position
        guard let accessibilityElement = AccessibilityInfo.getElement(at: point) else {
            print("No element found at position")
            return
        }
        
        let element = accessibilityElement.element  // 获取 AXUIElement
        
        if rightClick {
            // Try right click action
            let _ = AXUIElementPerformAction(element, "AXRightClick" as CFString)
        } else if doubleClick {
            // Try double click action
            let _ = AXUIElementPerformAction(element, "AXDoubleClick" as CFString)
        } else {
            // Normal click
            let _ = AXUIElementPerformAction(element, kAXPressAction as CFString)
        }
    }
}

struct AccessibilityElement {
    let element: AXUIElement
    
    func getAllAttributes() -> [String: Any] {
        var attributes: [String: Any] = [:]
        var attributeNames: CFArray?
        
        // 获取所有属性名称
        guard AXUIElementCopyAttributeNames(element, &attributeNames) == .success,
              let attributeArray = attributeNames as? [String] else {
            return attributes
        }
        
        // 遍历每个属性并获取值
        for attributeName in attributeArray {
            var value: CFTypeRef?
            if AXUIElementCopyAttributeValue(element, attributeName as CFString, &value) == .success,
               let attributeValue = value {
                attributes[attributeName] = attributeValue
            }
        }
        
        return attributes
    }
    
    func getProcessInfo() -> String {
        var info = ""
        var pid: pid_t = 0
        
        if AXUIElementGetPid(element, &pid) == .success {
            info += "PID: \(pid)\n"
            
            let workspace = NSWorkspace.shared
            if let app = workspace.runningApplications.first(where: { $0.processIdentifier == pid }) {
                info += "Process Name: \(app.localizedName)\n"
                if let bundleId = app.bundleIdentifier {
                    info += "Bundle ID: \(bundleId)\n"
                }
            }
        }
        
        return info
    }
    
    func setValue(_ text: String) -> Bool {
        // Set focus using AXFocusAttribute
        let focusResult = AXUIElementSetAttributeValue(element, "AXFocused" as CFString, true as CFBoolean)
        Thread.sleep(forTimeInterval: 0.1)
        
        // Set the text value
        let value = text as CFTypeRef
        let result = AXUIElementSetAttributeValue(element, kAXValueAttribute as CFString, value)
        
        if result == .success {
            // Press Return using AX action
            let returnResult = AXUIElementPerformAction(element, kAXPressAction as CFString)
            return returnResult == .success
        }
        return false
    }
    
    func isTextField() -> Bool {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, kAXRoleAttribute as CFString, &value) == .success,
              let role = value as? String else {
            return false
        }
        return role == "AXTextField"
    }
    
    func getAllInfo(depth: Int = 0) -> String {
        var info = "Element Information:\n"
        
        // 获取所有 AX 属性
        let attributes = getAllAttributes()
        info += "\nAccessibility Attributes:\n"
        for (key, value) in attributes.sorted(by: { $0.key < $1.key }) {
            let valueStr = String(describing: value)
            if !valueStr.isEmpty && valueStr != "0" && valueStr != "(null)" {
                info += "- \(key): \(valueStr)\n"
            }
        }
        
        // 获取进程信息
        let processInfo = getProcessInfo()
        if !processInfo.isEmpty {
            info += "\nProcess Information:\n"
            info += processInfo
        }
        
        // 添加可执行的操作信息
        var actions: CFArray?
        if AXUIElementCopyActionNames(element, &actions) == .success,
           let actionArray = actions as? [String] {
            info += "\nAvailable Actions:\n"
            for action in actionArray {
                info += "- \(action)\n"
            }
        }
        
        // 获取父节点信息
        if let parent = getParent() {
            // 检查父节点的子节点是否包含当前元素
            if isChildOfParent(parent: parent) {
                // 如果父节点正确包含了当前元素，继续递归
                info += "\n" + String(repeating: "  ", count: depth) + "Parent:\n"
                info += parent.getAllInfo(depth: depth + 1)
            } else {
                // 如果父节点没有包含当前元素，输出警告并停止递归
                info += "\n" + String(repeating: "  ", count: depth) + "Parent (Warning: Parent's children list doesn't include this element, stopping recursion)\n"
            }
        }
        
        return info
    }
    
    private func getParent() -> AccessibilityElement? {
        var parentRef: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(element, kAXParentAttribute as CFString, &parentRef)
        if result == .success {
            let parent = parentRef as! AXUIElement
            return AccessibilityElement(element: parent)
        }
        return nil
    }
    
    private func isChildOfParent(parent: AccessibilityElement) -> Bool {
        var childrenRef: CFTypeRef?
        guard AXUIElementCopyAttributeValue(parent.element, kAXChildrenAttribute as CFString, &childrenRef) == .success else {
            return false
        }
        
        let children = childrenRef as! [AXUIElement]
        
        // 比较每个子元素与当前元素
        for childElement in children {
            if childElement === element {
                return true
            }
        }
        
        return false
    }
}

class AccessibilityInfo {
    static func getElement(at point: CGPoint) -> AccessibilityElement? {
        let application = AXUIElementCreateSystemWide()
        
        var element: AXUIElement?
        let result = AXUIElementCopyElementAtPosition(application, Float(point.x), Float(point.y), &element)
        
        if result != .success {
            print("Error getting element: \(result.rawValue)")
            return nil
        }
        
        if let element = element {
            return AccessibilityElement(element: element)
        }
        return nil
    }
}

struct ContentView: View {
    @State private var elementInfo: String = "Enter coordinates to identify UI element"
    @State private var xCoordinate: String = "325"
    @State private var yCoordinate: String = "1160"
    @State private var appPath: String = ""
    @State private var inputText: String = ""
    @State private var currentElement: AccessibilityElement?
    @State private var isTextField: Bool = false
    @State private var hiddenElements: Set<AXUIElement> = []  // 记录被隐藏的元素
    
    var body: some View {
        VStack(spacing: 16) {
            // 坐标输入区域
            HStack {
                TextField("X", text: $xCoordinate)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                
                TextField("Y", text: $yCoordinate)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                
                Button("Identify Element") {
                    identifyElement()
                }
            }
            .padding(.horizontal)
            
            // 鼠标控制按钮
            HStack {
                Button("Click") {
                    if let x = Double(xCoordinate),
                       let y = Double(yCoordinate) {
                        DispatchQueue.global(qos: .userInteractive).async {
                            MouseControl.moveAndClick(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                
                Button("Right Click") {
                    if let x = Double(xCoordinate),
                       let y = Double(yCoordinate) {
                        DispatchQueue.global(qos: .userInteractive).async {
                            MouseControl.moveAndClick(to: CGPoint(x: x, y: y), rightClick: true)
                        }
                    }
                }
                
                Button("Double Click") {
                    if let x = Double(xCoordinate),
                       let y = Double(yCoordinate) {
                        DispatchQueue.global(qos: .userInteractive).async {
                            MouseControl.moveAndClick(to: CGPoint(x: x, y: y), doubleClick: true)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            // 文本输入区域（仅当选中文本框时显示）
            if isTextField {
                HStack {
                    TextField("Enter text to set", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: .infinity)
                    
                    Button("Set Text") {
                        setTextToElement()
                    }
                }
                .padding(.horizontal)
            }
            
            if let element = currentElement {
                HStack {
                    Button(hiddenElements.contains(element.element) ? "Show Element" : "Hide Element") {
                        toggleElementVisibility(element)
                    }
                }
                .padding(.horizontal)
            }
            
            // 信息显示区域
            ScrollView {
                Text(elementInfo)
                    .font(.system(size: 12, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .frame(maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .padding()
        }
        .frame(minWidth: 500, minHeight: 400)
    }
    
    private func identifyElement() {
        if let x = Double(xCoordinate),
           let y = Double(yCoordinate) {
            if let element = AccessibilityInfo.getElement(at: CGPoint(x: x, y: y)) {
                currentElement = element
                elementInfo = element.getAllInfo()
                isTextField = element.isTextField()
            } else {
                currentElement = nil
                elementInfo = "No element found at this location"
                isTextField = false
            }
        } else {
            currentElement = nil
            elementInfo = "Please enter valid coordinates"
            isTextField = false
        }
    }
    
    private func setTextToElement() {
        guard let element = currentElement else {
            elementInfo += "\nNo element selected"
            return
        }
        
        if element.setValue(inputText) {
            elementInfo += "\nSuccessfully set text with CR+LF characters"
            // 打印实际设置的内容，方便调试
            elementInfo += "\nActual text sent: \(inputText + "\\n")"
        } else {
            elementInfo += "\nFailed to set text"
        }
    }
    
    private func toggleElementVisibility(_ element: AccessibilityElement) {
        if hiddenElements.contains(element.element) {
            // 显示元素
            let position = CGPoint(x: -10000, y: -10000)
            var axPosition = position
            if let axValue = AXValueCreate(.cgPoint, &axPosition) {
                let _ = AXUIElementSetAttributeValue(element.element, kAXPositionAttribute as CFString, axValue)
            }
            hiddenElements.remove(element.element)
        } else {
            // 隐藏元素
            var position: CFTypeRef?
            if AXUIElementCopyAttributeValue(element.element, kAXPositionAttribute as CFString, &position) == .success {
                // 保存当前位置
                hiddenElements.insert(element.element)
                
                // 移动到屏幕外
                let offscreenPosition = CGPoint(x: -10000, y: -10000)
                var axPosition = offscreenPosition
                if let axValue = AXValueCreate(.cgPoint, &axPosition) {
                    let _ = AXUIElementSetAttributeValue(element.element, kAXPositionAttribute as CFString, axValue)
                }
            }
        }
        
        // 重新获取元素信息
        identifyElement()
    }
}

#Preview {
    ContentView()
}
