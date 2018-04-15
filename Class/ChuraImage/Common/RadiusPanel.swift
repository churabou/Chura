import SnapKit


protocol RadiusPanelDelegate {
    
    func didSelectRadius(_ radius: CGFloat)
}

class RadiusPanel: BaseView {
    
    var delegate: RadiusPanelDelegate?
    fileprivate var buttons: [RadiusButton] = []
    fileprivate let buttonS: CGFloat = 50
    fileprivate let sizes: [CGFloat] = [7,11,15,20,25,30]

    @objc fileprivate func actionButton(_ sender: UIButton) {
        buttons.forEach { $0.isSelected = false}
        sender.isSelected = !sender.isSelected
        let radius = CGFloat(sender.tag * 5)
        delegate?.didSelectRadius(radius)
    }
    
    override func initializeView() {
        for i in 0..<6 {
            let button = RadiusButton()
            button.frame = CGRect(x: buttonS*CGFloat(i), y: 0, width: buttonS, height: buttonS)
            button.setUp(size: sizes[i])
            button.tag = i+1
            button.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
            buttons.append(button)
            addSubview(button)
        }
        //adobeのはデフォルトでこれが選択されている。
        buttons[3].isSelected = true
        update(.black)
    }
    
    func update(_ color: UIColor) {
        buttons.forEach { $0.hilightColor = color}
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




