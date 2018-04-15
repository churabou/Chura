//
//  EditTool.swift
//  ChuraImage
//
//  Created by ちゅーたつ on 2018/04/15.
//  Copyright © 2018年 ちゅーたつ. All rights reserved.
//

import Foundation


enum EditType {
    case draw, blur
    
    var title: String {
        switch self {
        case .draw: return "お絵かき"
        case .blur: return "ぼかし"
        }
    }
    
    func newTool(_ editor: EditorView ) -> BaseTool {
        
        switch self {
        case .draw: return DrawTool(editor)
        case .blur: return BlurTool(editor)
        }
    }
}

class EditTool {
    var current: EditType = .draw
    private var currentTool: BaseTool?
    
    let defaultTools: [EditType] = [
        .draw, .blur
    ]
    
    var editor: EditorView!
    init(_ editor: EditorView) {
        self.editor = editor
    }
    
    func setUp() {
        currentTool = current.newTool(editor)
        currentTool?.setUp()
    }
    
    func cleanUp() {
        currentTool?.cleanUp()
    }
    
    func execute() {
        currentTool?.execute()
    }
}
