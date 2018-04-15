import SnapKit

protocol ColorPanelDelegate {
    func didSelectColor(_ color: UIColor)
}

class ColorPanel: BaseView {
    
    var scrollView: UIScrollView = UIScrollView()
    var buttons: [ColorPanelButton] = []
    var delegate: ColorPanelDelegate?
    let buttonS: CGFloat = 30
    
    @objc private dynamic func actionColorButton(_ sender: ColorPanelButton) {
        buttons.forEach { $0.isSelected = false }
        sender.isSelected = true
        self.delegate?.didSelectColor(colors[sender.tag])
    }

    override func initializeView() {
        
        scrollView.setAutoLayout()
        scrollView.showsHorizontalScrollIndicator = true
        addSubview(scrollView)
        
        colors.enumerated().forEach({ index,color in
            
            let button = ColorPanelButton()
            button.setAutoLayout()
            button.backgroundColor = color
            button.layer.cornerRadius = buttonS/2
            button.clipsToBounds = true
            button.tag = index
            button.addTarget(self, action: #selector(actionColorButton), for: .touchUpInside)
            buttons.append(button)
            scrollView.addSubview(button)
        })
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        scrollView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        buttons.enumerated().forEach({ index, button in
            
            button.snp.makeConstraints({ make in
                
                make.centerY.equalToSuperview()
                make.size.equalTo(buttonS)
                
                if index == 0 {
                    make.left.equalToSuperview()
                }
                else {
                    let pre = buttons[index-1]
                    make.left.equalTo(pre.snp.right).offset(5)
                }
                if button == buttons.last {
                    make.right.equalToSuperview()
                }
            })
        })
    }
}


extension ColorPanel {
    
    var colors: [UIColor] {
        return [.black, .white, .red, .orange, .yellow, .green, .cyan, .blue, .magenta, .gray, .brown, .black,
                .white, .red, .orange, .yellow, .green, .cyan, .blue, .magenta, .gray, .brown, .black,
                .white, .red, .orange, .yellow, .green, .cyan, .blue, .magenta, .gray, .brown, .black,]
    }
}


class ColorPanelButton: UIButton {
    
    
    override var isSelected: Bool {
        didSet {
            //黒の時だけ白でハイライト
            let color = backgroundColor == .black ? UIColor.white : UIColor.gray
            boderLayer.borderColor = isSelected ? color.cgColor : backgroundColor?.cgColor
        }
    }
    
    fileprivate lazy var boderLayer: CALayer = {
        let l = CALayer()
        let s = frame.width-5
        let x = layer.frame.width / 2
        let y = layer.frame.height / 2
        l.frame.origin = CGPoint(x: x-s/2, y: y-s/2)
        l.frame.size = CGSize(width: s, height: s)
        l.cornerRadius = s/2
        l.borderWidth = 2
        l.borderColor = backgroundColor?.cgColor
        l.backgroundColor = backgroundColor?.cgColor
        return l
    }()
    
    
    private var initialized = false
    override func draw(_ rect: CGRect) {
        layer.addSublayer(boderLayer)
        
        if !initialized {
            //初期値で黒を選択したいので描写のタイミングでかく。
            //すると他のタミングでも呼ばれてしまうのでフラグを設けた。
            //make black selected at first
            if boderLayer.backgroundColor == UIColor.black.cgColor {
                isSelected = true
            }
            initialized = true
        }
    }
}
