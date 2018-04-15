//
//  EditorView.swift
//  ChuraImage
//
//  Created by ちゅーたつ on 2018/04/15.
//  Copyright © 2018年 ちゅーたつ. All rights reserved.
//

import UIKit

class EditorView: BaseView {
    
    internal var menuView: UIView = UIView()
    internal var imageView: UIImageView = UIImageView()
    
    func update(image: UIImage) {
        imageView.image = image
        makeImageViewAspectFit()
    }

    fileprivate var imageWrapperView = UIView()
    fileprivate var topWrapperView = UIView() // [cancel] [title] [done]

    fileprivate lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "画像編集"
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()
    
    func update(title: String) {
        titleLabel.text = title
    }
    
    fileprivate lazy var doneButton: UIButton = {
        let b = UIButton()
        b.setTitle("完了", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.addTarget(self, action: #selector(actionDone), for: .touchUpInside)
        return b
    }()
    
    @objc private func actionDone() {
        
    }
    
    fileprivate lazy var cancelButton: UIButton = {
        let b = UIButton()
        b.setTitle("キャンセル", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.addTarget(self, action: #selector(actionCancel), for: .touchUpInside)
        return b
    }()
    
    @objc private func actionCancel() {
        
    }
    
    override func initializeView() {
        imageWrapperView.backgroundColor = .orange
        addSubview(imageWrapperView)
        imageWrapperView.addSubview(imageView)
        
        topWrapperView.backgroundColor = .red
        addSubview(topWrapperView)

        topWrapperView.addSubview(titleLabel)
        topWrapperView.addSubview(doneButton)
        topWrapperView.addSubview(cancelButton)
        menuView.backgroundColor = .cyan
        addSubview(menuView)
    }
    
    override func updateConstraints() {
        
        super.updateConstraints()
        imageWrapperView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalTo(topWrapperView.snp.top).offset(-10)
        }
        
        titleLabel.snp.makeConstraints({ make in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.center.equalToSuperview()
        })
        
        cancelButton.snp.makeConstraints({ make in
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        })
        
        doneButton.snp.makeConstraints({ make in
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        })
        
        
        topWrapperView.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
            make.bottom.equalTo(menuView.snp.top)
        })
        
        menuView.snp.makeConstraints({ make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(120)
        })
    }
}


extension EditorView {
    //UIImageViewのextensionにすべきか検討
    func makeImageViewAspectFit(){
        
        let image = imageView.image!
        
        let max_W: CGFloat = UIScreen.main.bounds.width-30
        let max_H: CGFloat = UIScreen.main.bounds.height-20-164//imageWrapperView.frame.height
        
        //Width/Height
        let wrapperViewAspect = max_W / max_H
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        //画像が縦長の場合
        //Width/Height
        let imageAspect = image.size.width / image.size.height
        if imageAspect < 1 {//縦長
            
            //横の長さもwrapperViewに収まる。
            if imageAspect <= wrapperViewAspect {
                height = max_H
                width = height * imageAspect
            } else {
                //                height = max_H
                //                width = height * imageAspect //このままだと横にはみ出てしまう。
                width = max_W
                height = width / imageAspect
            }
        } else { //wrapperViewが縦長なので横長もしくは正方形の場合収まる。
            width = max_W
            height = width / imageAspect
        }
        
        imageView.snp.remakeConstraints({ make in
            make.width.equalTo(width)
            make.height.equalTo(height)
            make.center.equalToSuperview()
        })
    }
}

