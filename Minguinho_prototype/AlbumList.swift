//
//  AlbumList.swift
//  Minguinho_prototype
//
//  Created by Eric Jeong on 08/06/2019.
//  Copyright © 2019 boychaboy. All rights reserved.
//

import UIKit

class Album: NSObject {
    var albumName = ""
    
    init(name: String) {
        self.albumName = name
        super.init()
    }
}
