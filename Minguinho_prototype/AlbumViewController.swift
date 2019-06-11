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
    
    let impact = UIImpactFeedbackGenerator()
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    @IBOutlet weak var addAlbum: MDCFloatingButton!
    @IBAction func unwind (segue : UIStoryboardSegue) {}
    
    @IBAction func addButtonPressed(_ sender: Any) {
        impact.impactOccurred()
    }
    
    let formatter: DateFormatter = {
        let d = DateFormatter()
        d.dateStyle = .medium
        d.dateFormat = "yyyy.MM"
        return d
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.shared.albumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumView", for: indexPath) as! AlbumCollectionViewCell
        let album = DataManager.shared.albumList[indexPath.row]
        cell.albumName.text = album.albumName
        if let albumImage = UIImage(data: (album.albumImage)!){
            cell.albumImage.image = albumImage
        }
        cell.albumYear.text = formatter.string(for: album.albumDate)
        cell.albumImage.layer.cornerRadius = 5.0
//        print(cell.albumName.text!)
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
            let target = DataManager.shared.albumList[index.row]
            vc.album = target
            vc.index = index
//            print("album send to vc at row for \(index.row)")
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataManager.shared.fetchAlbum()
        deleteBlank()
        albumCollectionView.reloadData()
    }
    
    func deleteBlank(){
        if DataManager.shared.albumList.count > 0 {
//            print(DataManager.shared.albumList.count)
            let target = DataManager.shared.albumList[0]
            if target.albumName == "" {
                print("no title!")
                DataManager.shared.deleteAlbum(target)
                DataManager.shared.albumList.remove(at: 0)
                //self.deleteRows(at: [indexPath], with: .fade)*/
//                print(DataManager.shared.albumList.count)
            }
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
