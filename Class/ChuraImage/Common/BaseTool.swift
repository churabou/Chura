
import SnapKit


protocol BaseTool {
    func setUp()
    func cleanUp()
    func execute()
}

protocol MenuViewProtocol: class {
    associatedtype DelegateType
    var delegate: DelegateType{ get set }
}

extension MenuViewProtocol where Self: UIView {
    
    func setUp(_ menuView: UIView, delegate: DelegateType) {
        menuView.addSubview(self)
        self.delegate = delegate
        snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
}

extension UIView {
    func setAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}

class BaseView: UIView {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeView() {}
}


