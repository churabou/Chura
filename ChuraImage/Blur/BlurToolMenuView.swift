import UIKit

protocol BlurToolMenuViewDelegate: class {
    func onClickMenuButton(_ sender: UIButton)
}

class BlurToolMenuView: BaseView, MenuViewProtocol {
    
    var delegate: BlurToolMenuViewDelegate?
    var wrapperView = UIView()
    var buttons: [UIButton] = []

    @objc private func onClickMenuButton(_ sender: UIButton) {
        buttons.forEach { $0.isSelected = false}
        sender.isSelected = true
        self.delegate?.onClickMenuButton(sender)
    }
    
    override func initializeView() {
    
//        backgroundColor = .editorMenuColor
        let centerX = UIScreen.main.bounds.width / 2
        wrapperView.frame = CGRect(x: centerX-75, y: 25, width: 150, height: 50)
        addSubview(wrapperView)
        for i in 0..<3 {
            let button = RadiusButton()
            button.frame = CGRect(x: CGFloat(i*50), y: 0, width: 50, height: 50)
            button.setUp(size: CGFloat(10*(i+1)))
            button.hilightColor = .orange
            button.tag = i
            button.addTarget(self, action: #selector(onClickMenuButton), for: .touchUpInside)
            buttons.append(button)
            wrapperView.addSubview(button)
        }
    }
}


class RadiusButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            circleLayer.borderColor = isSelected ? hilightColor.cgColor : UIColor.white.cgColor
        }
    }
    
    var hilightColor = UIColor.white {
        didSet {
            if isSelected { circleLayer.borderColor = hilightColor.cgColor  }
        }
    }
    
    var circleLayer = CALayer()
    
    func setUp(size: CGFloat) {
        circleLayer.cornerRadius = size/2
        circleLayer.backgroundColor = UIColor.red.cgColor
        circleLayer.borderColor = UIColor.white.cgColor
        circleLayer.borderWidth = 2
        
        let x = layer.frame.width / 2
        let y = layer.frame.height / 2
        circleLayer.frame.origin = CGPoint(x: x-size/2, y: y-size/2)
        circleLayer.frame.size = CGSize(width: size, height: size)
        layer.addSublayer(circleLayer)
    }
}
