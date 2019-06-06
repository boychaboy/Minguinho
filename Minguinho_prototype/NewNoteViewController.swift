//
//  NewNoteViewController.swift
//  Minguinho_prototype
//
//  Created by Eric Jeong on 06/06/2019.
//  Copyright © 2019 boychaboy. All rights reserved.
//

import UIKit

class NewNoteViewController: UIViewController {

    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteAlbum: UITextField!
    @IBOutlet weak var noteContent: UITextView!
    
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    
    deinit {
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    var note: Note?
    
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
        noteTitle.becomeFirstResponder()
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(shareButton))
        
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let title = noteTitle.text
        let album = noteAlbum.text
        let content = noteContent.text
        DataManager.shared.addNewNote(title, album, content)
        dismiss(animated: true, completion: nil)
        
        super.viewWillDisappear(animated)
        noteTitle.resignFirstResponder()
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
