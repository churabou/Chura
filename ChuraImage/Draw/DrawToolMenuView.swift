import UIKit

protocol DrawToolMenuViewDelegate {
    
    func didSelectColor(_ color: UIColor)
    func didSelectWidth(_ width: CGFloat)
    func didSelectEraser()
}

class DrawToolMenuView: BaseView, MenuViewProtocol {
    
    var delegate: DrawToolMenuViewDelegate?
    
    fileprivate var buttons: [UIButton] = []
    fileprivate var radiusPanel = RadiusPanel()
    fileprivate let colorPanel = ColorPanel()
    fileprivate var eraser = UIButton()

    
    override func initializeView() {
        
        backgroundColor = UIColor.gray

        radiusPanel.delegate = self
        let centerX = UIScreen.main.bounds.width / 2
        radiusPanel.frame.origin = CGPoint(x: centerX-150, y: 0)
        radiusPanel.frame.size = CGSize(width: 300, height: 50)
        addSubview(radiusPanel)
        
        colorPanel.setAutoLayout()
        colorPanel.delegate = self
        addSubview(colorPanel)

        eraser.setAutoLayout()
        eraser.backgroundColor = .white
        eraser.setTitle("消", for: .normal)
        eraser.setTitleColor(.black, for: .normal)
        eraser.addTarget(self, action: #selector(actionEraser), for: .touchUpInside)
        addSubview(eraser)
    }
    
    
    @objc fileprivate func actionEraser() {
        delegate?.didSelectEraser()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        eraser.snp.makeConstraints({ make in
            
            make.size.equalTo(50)
            make.left.bottom.equalToSuperview()
        })
        
        colorPanel.snp.makeConstraints({ make in
            
            make.height.equalTo(50)
            make.left.equalTo(eraser.snp.right)
            make.right.bottom.equalToSuperview()
        })
    }
}


extension DrawToolMenuView: ColorPanelDelegate {
    
    func didSelectColor(_ color: UIColor) {
        radiusPanel.update(color)
        delegate?.didSelectColor(color)
    }
}

extension DrawToolMenuView: RadiusPanelDelegate {
    
    func didSelectRadius(_ radius: CGFloat) {
        delegate?.didSelectWidth(radius)
    }
}
