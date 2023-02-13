//
//  ViewController.swift
//  VSwitch
//
//  Created by vicgillx on 02/10/2023.
//  Copyright (c) 2023 vicgillx. All rights reserved.
//

import UIKit
import VSwitch
import SwifterSwift
import SnapKit

class ViewController: UIViewController {
    
    let item1:[VSwitch.Item] = [VSwitch.Item(title: "public",backgroundColor: .green),.init(title: "private",backgroundColor: .red)]
    
    let item2 = [VSwitch.Item(image: UIImage(named: "icon_man"),title: "man",backgroundColor: UIColor(hex: 0x29BFFF)!),VSwitch.Item(image: UIImage(named: "icon_woman"),title: "woman",backgroundColor: UIColor(hex: 0xEA3873))]
    
    let item3 = [VSwitch.Item(title: "red",backgroundColor: .red),.init(title: "green",backgroundColor: .green),.init(title:"blue",backgroundColor: .blue),.init(title:"black",backgroundColor: .black)]
    
    let item4:[VSwitch.Item] = [
        .init(title: "swift",backgroundColor:.white),
        .init(title: "golang",backgroundColor: .white),
        .init(title:"python",backgroundColor: .white)]

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func initViews() {
        let switch1 = VSwitch(items: item1,selectedIndex: 1)
        switch1.backgroundColor = .black
        switch1.offColor = UIColor.white
        switch1.onColor = UIColor.black
        view.addSubview(switch1)
        NSLayoutConstraint.activate([
            switch1.topAnchor.constraint(equalTo: view.topAnchor,constant: 100),
            switch1.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let switch2 = VSwitch(items: item2,itemInsetSpacing: 2,padding: 4)
        switch2.backgroundColor = UIColor(hex: 0xF6F7F9)
        switch2.offColor = UIColor(hex: 0xB7B7B7)
        switch2.onColor = UIColor.white
        switch2.reloadCornerRadius(radius: 30)
        view.addSubview(switch2)
        NSLayoutConstraint.activate([
            switch2.topAnchor.constraint(equalTo: switch1.bottomAnchor,constant: 20),
            switch2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            switch2.heightAnchor.constraint(equalToConstant: 60),
            switch2.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        let switch3 = VSwitch(items: item3,padding: 8)
        switch3.backgroundColor = UIColor.brown
        switch3.offColor = UIColor.yellow
        switch3.onColor = UIColor.white
        switch3.reloadCornerRadius(radius: 40)
        
        view.addSubview(switch3)
        switch3.snp.makeConstraints {
            $0.top.equalTo(switch2.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 300, height: 80))
        }
        
        let switch4 = VSwitch(items: item4,selectedIndex: 1)
        switch4.backgroundColor = UIColor(hex: 0x29BFFF)!
        switch4.offColor = .white
        switch4.onColor = UIColor(hex: 0x29BFFF)!
        switch4.reloadCornerRadius(radius: 20)
        view.addSubview(switch4)
        switch4.snp.makeConstraints {
            $0.top.equalTo(switch3.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
            $0.height.equalTo(40)
        }
        
    }

}
