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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumView", for: indexPath)
        return cell
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
