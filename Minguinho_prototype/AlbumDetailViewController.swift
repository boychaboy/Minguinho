//
//  AlbumDetailViewController.swift
//  Minguinho_prototype
//
//  Created by Eric Jeong on 08/06/2019.
//  Copyright © 2019 boychaboy. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class AlbumDetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var album: Album?
    var index: IndexPath = []
    var albumCnt : Int = 0
    var albumNotes = [Note]()
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return albumNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumNoteList", for: indexPath)
        cell.textLabel?.text = albumNotes[indexPath.row].title!
        return cell
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
        
        albumCnt = 0
        let cnt = DataManager.shared.noteList.count
        for i in 0..<cnt {
            if DataManager.shared.noteList[i].album == album?.albumName
            {
                albumCnt = albumCnt + 1
                albumNotes.append(DataManager.shared.noteList[i])
            }
        }
        print(albumNotes.count)
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
