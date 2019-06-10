//
//  NewNoteViewController.swift
//  Minguinho_prototype
//
//  Created by Eric Jeong on 06/06/2019.
//  Copyright © 2019 boychaboy. All rights reserved.
//

import UIKit
import Marklight

class NewNoteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    

    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteAlbum: UITextField!
    @IBOutlet weak var noteContent: UITextView!
    
    @IBOutlet weak var recommendView: UICollectionView!
    
    
    
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    
//    let textStorage = MarklightTextStorage()
    
    deinit {
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    var note: Note?
    var recommend = [String]()
    /* Problem with no note centent not solved yet
     
    @objc func shareButton() {
        guard let note = note?.content else {
            print("no item to share")
            return
        }
        let vc = UIActivityViewController(activityItems: [note], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recommendView.delegate = self
        recommendView.dataSource = self
        noteTitle.becomeFirstResponder()
        // Do any additional setup after loading the view.
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(shareButton))
        
        /*textStorage.addLayoutManager(noteContent.layoutManager)
        let string = self.textStorage.string
        let attributedString = NSAttributedString(string: string)
        self.noteContent.attributedText = attributedString
        self.textStorage.append(attributedString)*/
        
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in guard let strongSelf = self else {return}
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height
                var inset = strongSelf.noteContent.contentInset
                inset.bottom = height
                strongSelf.noteContent.contentInset = inset
                
                inset = strongSelf.noteContent.scrollIndicatorInsets
                inset.bottom = height
                strongSelf.noteContent.scrollIndicatorInsets = inset
            }
        })
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in guard let strongSelf = self else {return}
            
            var inset = strongSelf.noteContent.contentInset
            inset.bottom = 0
            strongSelf.noteContent.contentInset = inset
            
            inset = strongSelf.noteContent.scrollIndicatorInsets
            inset.bottom = 0
            strongSelf.noteContent.scrollIndicatorInsets = inset
        })
        
        generateWords()
        noteContent.inputAccessoryView = recommendView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let title = noteTitle.text
        let album = noteAlbum.text
        let content = noteContent.text
        
        //let content = self.textStorage.string
        DataManager.shared.addNewNote(title, album, content)
        dismiss(animated: true, completion: nil)
        super.viewWillDisappear(animated)
        noteTitle.resignFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommend.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendWord2", for: indexPath) as! RecommendCollectionViewCell
        cell.recommendWord2.text = recommend[indexPath.row]
        
        return cell
    }

    //temporary
    func generateWords() {
        recommend.append("하와이")
        recommend.append("쌈마이")
        recommend.append("Shine my")
        recommend.append("카와이")
        recommend.append("까나리")
        recommend.append("나와이")
        recommend.append("Find mine")
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
