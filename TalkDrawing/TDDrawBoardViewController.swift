//
//  TDDrawBoardViewController.swift
//  TalkDrawing
//
//  Created by 何纪栋 on 2023/7/26.
//

import UIKit
import SwiftUI

// 遵循UIViewControllerRepresentable协议
struct DrawBoardView: UIViewControllerRepresentable {
    
    let vc = TDDrawBoardViewController()
    func makeUIViewController(context: Context) -> some UIViewController {
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}
class TDDrawBoardViewController: UIViewController {

    var drawBoardView = TDDrawBoardView()
    var colorGroup = TDColorGroupView()
    
    var clearButton = UIButton()
    
    var backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.contents = UIImage(named:"background")?.cgImage
        self.view.addSubview(drawBoardView)
        drawBoardView.backgroundColor = .lightGray
        drawBoardView.layout {
            $0.height == 800
            $0.width == 800
            $0.centerX == $0.superview.centerX
            $0.centerY == $0.superview.centerY
        }
        
        self.view.addSubview(colorGroup)
        colorGroup.layout {
//            $0.width == 120
            $0.leading == drawBoardView.trailing + 20
            $0.top == drawBoardView.top
        }
        
        self.view.addSubview(clearButton)
        clearButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        clearButton.imageView?.tintColor = UIColor(.accentColor)
        clearButton.imageView?.layout(using: { view in
            view.height == 100
            view.width == 100
        })
        clearButton.addTarget(self, action: #selector(clearDrawBoard), for: .touchUpInside)
        clearButton.layout {
            $0.leading == $0.superview.leading + 20
            $0.height == 100
            $0.width == 100
            $0.top == drawBoardView.top
        }
        
        self.view.addSubview(backButton)
        backButton.setImage(UIImage(systemName: "gobackward"), for: .normal)
        backButton.imageView?.layout(using: { view in
            view.height == 100
            view.width == 100
        })
        backButton.imageView?.tintColor = UIColor(.accentColor)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        backButton.layout {
            $0.leading == $0.superview.leading + 20
            $0.height == 100
            $0.width == 100
            $0.top == clearButton.bottom
        }
        // Add tap gesture recognizer to each color block in colorGroup
//        for colorBlock in colorGroup.colorBlocks {
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectColor(_:)))
//            colorBlock.addGestureRecognizer(tapGesture)
//        }
        // Do any additional setup after loading the view.
    }
    
    @objc func clearDrawBoard(_ sender: Any) {
        self.drawBoardView.clear()
    }
    
    @objc func back(_ sender: Any) {
        self.drawBoardView.back()
    }
    
//    @objc func selectColor(_ sender: UITapGestureRecognizer) {
//        guard let colorBlock = sender.view else { return }
//            let selectedColor = colorBlock.backgroundColor ?? .black
//            drawBoardView.lineColor = selectedColor
//        }
}
