//
//  AddAlbumViewController.swift
//  Minguinho_prototype
//
//  Created by Eric Jeong on 08/06/2019.
//  Copyright © 2019 boychaboy. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class AddAlbumViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var album : Album?

    @IBOutlet weak var albumName: UITextField!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var photoButton: MDCFloatingButton!
    
    @IBAction func addPhoto(_ sender: Any) {
        print("Button pressed!")
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: false, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        albumName.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        let title = albumName.text
        //let content = self.textStorage.string
//        DataManager.shared.addNewAlbum(title, Image)
        albumName.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        super.viewWillDisappear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        albumName.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumName.becomeFirstResponder()
        let albumImage = UIImage(named: "photo")?.withRenderingMode(.alwaysTemplate)
        photoButton.setImage(albumImage, for: .normal)
        photoButton.setElevation(ShadowElevation(rawValue: 6), for: .normal)
        photoButton.setBackgroundColor(UIColor(red: 142/255, green: 250/255,  blue: 0/255, alpha: 1))
        
        // Do any additional setup after loading the view.
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            albumImage.image = image
        }
        //self.albumImage.image =  info[UIImagePickerControllerOriginalImage] as? UIImage
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
