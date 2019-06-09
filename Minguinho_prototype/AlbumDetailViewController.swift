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
    
    @IBOutlet weak var deleteAlbum: MDCFloatingButton!
    
    @IBOutlet weak var albumImage: UIImageView!
    
    @IBOutlet weak var albumList: UITableView!
    
    @IBAction func deleteAlbumAction(_ sender: Any) {
        DataManager.shared.deleteAlbum(album)
        DataManager.shared.albumList.remove(at: index.row)
        self.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "unwind", sender: self)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        let deleteImage = UIImage(named: "211835-512-29")?.withRenderingMode(.alwaysOriginal)
        deleteAlbum.setImage(deleteImage, for: .normal)
        deleteAlbum.setElevation(ShadowElevation(rawValue: 6), for: .normal)
        deleteAlbum.setBackgroundColor(UIColor(red: 255/255, green: 0/255,  blue: 0/255, alpha: 1))
        // Do any additional setup after loading the view.
        self.albumName.text = album?.albumName
        if let getImage = UIImage(data: (album!.albumImage)!){
                self.albumImage.image = getImage
        }
        
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
