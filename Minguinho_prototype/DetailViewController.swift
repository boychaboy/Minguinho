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

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate {

    
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteAlbum: UITextField!
    @IBOutlet weak var noteContent: UITextView!

    @IBOutlet weak var recommendView: UICollectionView!
    
    
    deinit {
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    var note: Note?
//    var index: IndexPath = []
    var indexRow: Int = 0
//    let textStorage = MarklightTextStorage()
    
    var recommend = [String]()
    
//    @IBOutlet weak var recordButton: MDCFloatingButton!
    
    @objc func shareButton() {
        guard let note = note?.content else {
            print("no item to share")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [note], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.noteContent.addObserver(self, forKeyPath: "selectedTextRange", options: NSKeyValueObservingOptions(rawValue: NSKeyValueObservingOptions.new.rawValue|NSKeyValueObservingOptions.old.rawValue), context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if((keyPath == "selectedTextRange")){
            if let text = wordBeforeCursor(){
                print(text)
            }
            else{
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(shareButton))
        
        recommendView.delegate = self
        recommendView.dataSource = self
//        noteContent.delegate = self
//        let recordImage = UIImage(named: "record")?.withRenderingMode(.alwaysOriginal)
//        recordButton.setImage(recordImage, for: .normal)
//        recordButton.setElevation(ShadowElevation(rawValue: 6), for: .normal)
//        recordButton.setBackgroundColor(UIColor(red: 0, green: 144/255,  blue: 81/255, alpha: 1))
//        
        self.noteTitle.text = note?.title
        self.noteAlbum.text = note?.album
        self.noteContent.text = note?.content
        
//        textStorage.addLayoutManager(noteContent.layoutManager)
//        let string = (note?.content)!
//        let attributedString = NSAttributedString(string: string)
//        self.noteContent.attributedText = attributedString
//        self.textStorage.append(attributedString)
        
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
        
        // Do any additional setup after loading the view.
        generateWords()
        noteContent.inputAccessoryView = recommendView
//        if let selectedRange = noteContent.selectedTextRange {
//            let cursorPosition = noteContent.offset(from: noteContent.beginningOfDocument, to: selectedRange.start)
//
//            print("\(cursorPosition)")
//        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        
        DataManager.shared.noteList[indexRow].title = noteTitle.text
        DataManager.shared.noteList[indexRow].album = noteAlbum.text
        DataManager.shared.noteList[indexRow].content = noteContent.text
        
        DataManager.shared.saveContext()
        dismiss(animated: true, completion: nil)
        super.viewWillDisappear(animated)
        noteContent.resignFirstResponder()
    }
    
    
    
    func generateWords() {
        recommend.append("하와이")
        recommend.append("쌈마이")
        recommend.append("Shine my")
        recommend.append("카와이")
        recommend.append("까나리")
        recommend.append("나와이")
        recommend.append("Find mine")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommend.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendWord", for: indexPath) as! RecommendCollectionViewCell
        cell.recommendWord.text = recommend[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(recommend[indexPath.row])
        var text = self.noteContent.text
        text = text! + recommend[indexPath.row]
        self.noteContent.text = text
        return
    }
 
    func textBeforeCursor() -> String? {
        // get the cursor position
        if let cursorRange = noteContent.selectedTextRange {
            // get the position one character before the cursor start position
            if let newPosition = noteContent.position(from: cursorRange.start, offset: -3) {
                
                let range = noteContent.textRange(from: newPosition, to: cursorRange.start)
                return noteContent.text(in: range!)
            }
        }
        return nil
    }
    
    func wordBeforeCursor() -> String? {
        // get the cursor position
        let beginning = noteContent.beginningOfDocument
        
        if let start = noteContent.position(from: beginning, offset: noteContent.selectedRange.location), let end = noteContent.position(from: start, offset: noteContent.selectedRange.length){
            let textRange = noteContent.tokenizer.rangeEnclosingPosition(end, with: .word, inDirection: UITextDirection(rawValue: 1))
            if let textRange = textRange {
                return noteContent.text(in: textRange)
            }
        }
        return nil
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
