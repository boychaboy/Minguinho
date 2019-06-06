//
//  DetailViewController.swift
//  Minguinho_prototype
//
//  Created by Eric Jeong on 06/06/2019.
//  Copyright © 2019 boychaboy. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class DetailViewController: UIViewController {

    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteAlbum: UITextField!
    @IBOutlet weak var noteContent: UITextView!
    
    var note: Note?
    
    
    @IBOutlet weak var recordButton: MDCFloatingButton!
    
    @objc func shareButton() {
        print("Share button clicked")
        guard let note = note?.content else {
            print("no item to share")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [note], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(shareButton))
        
        let recordImage = UIImage(named: "record")?.withRenderingMode(.alwaysOriginal)
        recordButton.setImage(recordImage, for: .normal)
        recordButton.setElevation(ShadowElevation(rawValue: 6), for: .normal)
        recordButton.setBackgroundColor(UIColor(red: 0, green: 144/255,  blue: 81/255, alpha: 1))
        
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
