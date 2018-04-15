import UIKit

/*
①オリジナルをぼかした画像をコンテクストに描画
②オリジナルとマスク画像を合成した画像(ナゾったところが透明)
③コンテクストに②で作成した画像を描画
 */


fileprivate struct BlurToolCore {

    static func outputImage(from: UIImage, _ blured: UIImage, _ mask: UIImage ) -> UIImage {
        
        let original = from
        
        UIGraphicsBeginImageContextWithOptions(original.size, false, original.scale)
        
        blured.draw(at: .zero)
        
        let masked = original.maskedWith(image: mask)
        masked?.draw(in: CGRect(origin: .zero, size: original.size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

final class BlurTool {
    
    var editor: EditorView!
    init(_ editor: EditorView){
        self.editor = editor
    }
    
    fileprivate var menuView = BlurToolMenuView()
    fileprivate var drawingView: UIImageView = UIImageView()
    fileprivate var strokeWidth: CGFloat = 20.0
    fileprivate var panGesture = UIPanGestureRecognizer()
    fileprivate var preDraggingPosition: CGPoint!
    //input
    fileprivate var maskImage = UIImage()
    fileprivate var blurImage = UIImage()
}


extension BlurTool: BaseTool {
    
    func execute() {
        
        editor.image = BlurToolCore.outputImage(from: editor.image, blurImage, maskImage)
        cleanUp()
    }
    
    func cleanUp() {
        
        drawingView.removeFromSuperview()
        editor.imageView.isUserInteractionEnabled = false
        menuView.removeFromSuperview()
    }
    
    func setUp() {
        
        //menuView
        menuView = BlurToolMenuView()
        menuView.setUp(editor.menuView, delegate: self)
        
        //input
        maskImage = UIImage()
        blurImage = editor.image.discBlured(radius: 20)        
        print(blurImage.size)

        //drawingView
        editor.imageView.isUserInteractionEnabled = true
        drawingView = UIImageView()
        drawingView.frame = editor.imageView.bounds
        drawingView.image = editor.image
        drawingView.isUserInteractionEnabled = true
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(drawingViewDidPan(_:)))
        drawingView.addGestureRecognizer(panGesture)
        editor.imageView.addSubview(drawingView)
    }
}


extension BlurTool: BlurToolMenuViewDelegate {
    
    func onClickMenuButton(_ sender: UIButton){
        
        switch sender.tag {
        case 0:
            self.strokeWidth = 15
        case 1:
            self.strokeWidth = 30
        case 2:
            self.strokeWidth = 45
        default:
            print("sender tag is 0...2")
        }
    }
}


extension BlurTool {
    
    @objc dynamic func drawingViewDidPan(_ sender: UIPanGestureRecognizer) {

        let currentDraggingPosition: CGPoint = sender.location(in: drawingView)
        
        if sender.state == .began {
            preDraggingPosition = currentDraggingPosition
        }
        
        if sender.state != .ended {
            
            drawLine(from: preDraggingPosition, to: currentDraggingPosition)
            drawingView.image = BlurToolCore.outputImage(from: editor.image, blurImage, maskImage)
        }
        
        if sender.state == .ended {
        }
        
        preDraggingPosition = currentDraggingPosition
    }
    
    func drawLine(from: CGPoint, to: CGPoint){

        let size: CGSize = drawingView.frame.size

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            fatalError("context is nil")
        }
        
        maskImage.draw(at: CGPoint.zero)
        
        
        context.setLineWidth(strokeWidth)
        context.setLineCap(.round)
        context.setStrokeColor(UIColor.white.cgColor)
        
        context.move(to: from)
        context.addLine(to: to)
        context.strokePath()
        
        maskImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
    }
}


