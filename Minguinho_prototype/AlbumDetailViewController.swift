//
//  AlbumDetailViewController.swift
//  Minguinho_prototype
//
//  Created by Eric Jeong on 08/06/2019.
//  Copyright © 2019 boychaboy. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class AlbumDetailViewController: UIViewController {
    
    var album: Album?
    var index: IndexPath = []
    
    @IBOutlet weak var albumName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.albumName.text = album?.albumName
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
