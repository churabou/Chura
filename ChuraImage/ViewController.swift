//
//  ViewController.swift
//  ChuraImage
//
//  Created by ちゅーたつ on 2018/04/14.
//  Copyright © 2018年 ちゅーたつ. All rights reserved.
//

import UIKit

//enum EditTool {
//    case draw, blur
//    
//    var title: String {
//        switch self {
//        case draw: return "お絵かき"
//        case bluer: return "ぼかし"
//        }
//    }
//}

class ViewController: UIViewController {
    var v = EditorView()
    var mainMenu = MainMenu()
    var blurTool: BlurTool!
    var drawTool: DrawTool!
    
    var editTools: [BaseTool] = []
    var currentTool: BaseTool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        v = EditorView()
        v.delegate = self
        view.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        v.image = UIImage(named: "chura.jpg")!

        v.menuView.addSubview(mainMenu)
        
        mainMenu.delegate = self
        mainMenu.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        blurTool = BlurTool(v)
        drawTool = DrawTool(v)
        editTools = [blurTool, drawTool]
    }
    
}

extension ViewController: EditorViewDelegate {
    
    func didSelectCancel() {
        print("キャンセル")
        currentTool?.cleanUp()
    }
    
    func didSelectDone() {
        print("完了")
    }
}

extension ViewController: MainMenuDelegate {
    func didSelectMenu(at: Int) {
        print(at)
        let index = at % editTools.count
        currentTool = editTools[index]
        currentTool?.setUp()
    }
}




class MenuView: SegmentMenuView {
    
    fileprivate var doneButton = UIButton()

    override func initializeView() {
        
        segment = UISegmentedControl(items: ["segment","full"])
        let v1 = UIView()
        v1.backgroundColor = .red
        let v2 = UIView()
        v2.backgroundColor = .orange
        childViews = [v1, v2]
        super.initializeView()
        
        doneButton.setTitle("完了", for: .normal)
        doneButton.setTitleColor(.red, for: .normal)
        doneButton.backgroundColor = .white
        addSubview(doneButton)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        doneButton.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-10)
        }
    }
}

class SegmentMenuView: BaseView {

    fileprivate var segment = UISegmentedControl()
    fileprivate var scrollView = UIScrollView()
    fileprivate var childViews: [UIView] = []

    override func initializeView() {

        backgroundColor = .blue
        
        segment.tintColor = .red
        segment.addTarget(self, action: #selector(actionSegment), for: .valueChanged)
        addSubview(segment)
        
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        addSubview(scrollView)
        
        childViews.forEach { scrollView.addSubview($0) }
    }
    
    @objc private func actionSegment(_ sender: UISegmentedControl) {
        scroll(to: sender.selectedSegmentIndex)
    }
    
    override func updateConstraints() {
        super.updateConstraints()

        segment.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.width.equalTo(140)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(segment.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }
        
        childViews.enumerated().forEach { index, view in
            
            view.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.width.height.equalToSuperview()
                
                if view == childViews.first {
                    // 最初のViewはUIScrollViewの左側に設定する
                    make.left.equalToSuperview()
                } else {
                    let pre = childViews[index-1]
                    make.left.equalTo(pre.snp.right)
                }
                // 最後のViewはUIScrollViewの右側に設定する
                if view == childViews.last {
                    make.right.equalToSuperview()
                }
            }
        }
    }
    
    func scroll(to: Int) {
        
        let x = CGFloat(to) * scrollView.bounds.width
        UIView.animate(withDuration: 0.3) {
            
            self.scrollView.contentOffset.x = x
        }
    }
}

extension SegmentMenuView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let currentIndex = scrollView.contentOffset.x / scrollView.bounds.width
        segment.selectedSegmentIndex = Int(currentIndex)
    }
}

