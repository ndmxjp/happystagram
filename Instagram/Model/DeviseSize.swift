//
//  DeviceSize.swift
//  Instagram
//
//  Created by saito-takumi on 2018/01/02.
//  Copyright © 2018年 saito-takumi. All rights reserved.
//

import UIKit

struct DeviseSize {
    
    //CGRectを取得
    static func bounds()->CGRect{
        return UIScreen.main.bounds;
    }
    
    //画面の横サイズを取得
    static func screenWidth()->CGFloat{
        return CGFloat( UIScreen.main.bounds.size.width );
    }
    
    //画面の縦サイズを取得
    static func screenHeight()->CGFloat{
        return CGFloat( UIScreen.main.bounds.size.height );
    }
}
