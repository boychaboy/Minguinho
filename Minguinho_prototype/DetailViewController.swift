//
//  DetailViewController.swift
//  Minguinho_prototype
//
//  Created by Eric Jeong on 06/06/2019.
//  Copyright © 2019 boychaboy. All rights reserved.
//

import UIKit
import Marklight
import MaterialComponents.MaterialButtons

class DetailViewController: UIViewController {

    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteAlbum: UITextField!
    @IBOutlet weak var noteContent: UITextView!
    
    var note: Note?
    var index: IndexPath = []
    let textStorage = MarklightTextStorage()
    
    @IBOutlet weak var recordButton: MDCFloatingButton!
    
    @objc func shareButton() {
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
        
        
        
        self.noteTitle.text = note?.title
        self.noteAlbum.text = note?.album
        //self.noteContent.text = note?.content
        
        textStorage.addLayoutManager(noteContent.layoutManager)
        let string = (note?.content)!
        let attributedString = NSAttributedString(string: string)
        self.noteContent.attributedText = attributedString
        self.textStorage.append(attributedString)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        DataManager.shared.noteList[index.row].title = noteTitle.text
        DataManager.shared.noteList[index.row].album = noteAlbum.text
        DataManager.shared.noteList[index.row].content = self.textStorage.string
        
        DataManager.shared.saveContext()
        dismiss(animated: true, completion: nil)
        super.viewWillDisappear(animated)
        noteContent.resignFirstResponder()
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
