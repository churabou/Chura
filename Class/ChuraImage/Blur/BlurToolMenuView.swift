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

    override func draw(_ rect: CGRect) {
        
        let centerX = bounds.width / 2
        let centerY = bounds.height / 2
        wrapperView.frame = CGRect(x: centerX-75, y: centerY-25, width: 150, height: 50)
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

