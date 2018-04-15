//
//  MainMenu.swift
//  ChuraImage
//
//  Created by ちゅーたつ on 2018/04/15.
//  Copyright © 2018年 ちゅーたつ. All rights reserved.
//

import SnapKit

protocol MainMenuDelegate: class {
    func didSelectMenu(at: Int)
}
class CollectionCell: UICollectionViewCell {
    
    fileprivate var imageView = UIImageView()
    func setUp() {
        backgroundColor = .red
        imageView.backgroundColor = .blue
        contentView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        imageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(5)
            make.right.bottom.equalTo(-5)
        }
    }
}

class MainMenu: BaseView {
    
    weak var delegate: MainMenuDelegate?
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .green
        v.dataSource = self
        v.delegate = self
        v.alwaysBounceVertical = false
        v.scrollIndicatorInsets = .zero
        v.register(CollectionCell.self, forCellWithReuseIdentifier: "cell")
        return v
    }()
    
    override func initializeView() {
        
        addSubview(collectionView)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}



extension MainMenu: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Sketchのレイアウト比率に合わせる / w320px: 140x190
        
        let s = bounds.height/1.8
        return CGSize(width: s-10, height: s-10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
}

extension MainMenu: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.setUp()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectMenu(at: indexPath.row)
    }
}

