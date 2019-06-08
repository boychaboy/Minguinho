//
//  AlbumViewController.swift
//  Minguinho_prototype
//
//  Created by Eric Jeong on 08/06/2019.
//  Copyright © 2019 boychaboy. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class AlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    @IBOutlet weak var addAlbum: MDCFloatingButton!
    
    var albumList = [Album]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumView", for: indexPath) as! AlbumCollectionViewCell
        let album = albumList[indexPath.row]
        cell.albumName.text = album.albumName
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showAlbum") {
            guard let cell: UICollectionViewCell = sender as? UICollectionViewCell else {
                return
            }
            guard let index: IndexPath = self.albumCollectionView.indexPath(for: cell) else {
                return
            }
            guard let vc : AlbumDetailViewController = segue.destination as? AlbumDetailViewController else {
                return
            }
            let target = albumList[index.row]
            vc.album = target
            print(target.albumName)
            print("album send to vc at row for \(index.row)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        
        let plusImage = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
        addAlbum.setImage(plusImage, for: .normal)
        addAlbum.setElevation(ShadowElevation(rawValue: 6), for: .normal)
        addAlbum.setBackgroundColor(UIColor(red: 142/255, green: 250/255,  blue: 0/255, alpha: 1))
        // Do any additional setup after loading the view.
        
        var list = Album(name: "새 앨범")
        albumList.append(list)
        
        list = Album(name: "새 앨범2")
        albumList.append(list)
        
        list = Album(name: "새 앨범3")
        albumList.append(list)
        
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
