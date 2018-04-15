import UIKit

// オリジナル画像とお絵かきした画像を合成する

fileprivate struct DrawToolCore {

    static func outputImage(from: UIImage, drawingView: UIImageView) -> UIImage {
        
        let image = from
        let drownImage = drawingView.image
       
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        
        image.draw(at: CGPoint.zero)
        drownImage?.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output!
    }
}

class DrawTool {
    
    var editor: EditorView!
    
    init(_ editor: EditorView) {
        self.editor = editor
    }
    
    //MARK fileprivate
    
    fileprivate var menuView: DrawToolMenuView!
    fileprivate var drawingView = UIImageView()
    fileprivate var strokeColor: UIColor = .black
    fileprivate var strokeWidth: CGFloat = 20.0
    fileprivate var panGesture = UIPanGestureRecognizer()
    fileprivate var preDraggingPosition = CGPoint.zero
    fileprivate var isEraserSelected = false
}

extension DrawTool: BaseTool {
    
    func execute() {
        
        editor.image = DrawToolCore.outputImage(from: editor.image, drawingView: drawingView)
        cleanUp()
    }
    
    func cleanUp() {
        
        drawingView.removeFromSuperview()
        editor.imageView.isUserInteractionEnabled = false
        menuView.removeFromSuperview()
    }

    func setUp() {
        
        menuView = DrawToolMenuView()
        menuView.setUp(editor.menuView, delegate: self)
        
        //初期値
        strokeColor = .black
        strokeWidth = 20

        //drawingView
        drawingView = UIImageView()
        editor.imageView.isUserInteractionEnabled = true
        drawingView.frame = editor.imageView.bounds
        drawingView.isUserInteractionEnabled = true
        editor.imageView.addSubview(drawingView)
        
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(drawingViewDidPan(_:)))
        drawingView.addGestureRecognizer(panGesture)
    }
}

extension DrawTool {
    
    @objc fileprivate func drawingViewDidPan(_ sender: UIPanGestureRecognizer) {
        
        let currentDraggingPosition: CGPoint = sender.location(in: drawingView)
        
        if sender.state == .began {
            preDraggingPosition = currentDraggingPosition
        }
        if sender.state != .ended {
            
            drawLine(from: preDraggingPosition, to: currentDraggingPosition)
        }
        
        if sender.state == .ended {
        }
        
        preDraggingPosition = currentDraggingPosition
    }
    
    fileprivate func drawLine(from: CGPoint, to: CGPoint){
        
        let size: CGSize = drawingView.frame.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            fatalError("context is nil")
        }
        
        drawingView.image?.draw(at: CGPoint.zero)
        
        context.setLineWidth(strokeWidth)
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineCap(.round)
        
        if isEraserSelected {
            context.setBlendMode(.clear)
        }

        context.move(to: from)
        context.addLine(to: to)
        context.strokePath()
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
        drawingView.image = image
        
        UIGraphicsEndImageContext()
    }
}

extension DrawTool: DrawToolMenuViewDelegate {

    func didSelectColor(_ color: UIColor) {
        isEraserSelected = false
        strokeColor = color
    }
    
    func didSelectWidth(_ width: CGFloat) {
        strokeWidth = width
    }
    
    func didSelectEraser() {
        isEraserSelected = true
    }
}
