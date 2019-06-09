//
//  AddAlbumViewController.swift
//  Minguinho_prototype
//
//  Created by Eric Jeong on 08/06/2019.
//  Copyright © 2019 boychaboy. All rights reserved.
//

import UIKit


class AddAlbumViewController: UIViewController, UITextFieldDelegate {
    
    var album : Album?

    @IBOutlet weak var albumName: UITextField!
    @IBOutlet weak var albumImage: UIImageView!
    
    @IBAction func cancelButton(_ sender: Any) {
        albumName.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        let album = Album(name: albumName.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumName.becomeFirstResponder()
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
