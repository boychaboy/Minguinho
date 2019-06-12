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


//
private extension String {
    subscript(i:Int) -> Character {
        let idx = index(startIndex, offsetBy: i)
        return self[idx]
    }
}

struct Array2D<T> {
    let width: Int, height: Int
    var length: Int { return width * height }
    var data: [T?]
    var last: T? { return data.last! }
    
    init(width:Int, height: Int) {
        self.width = width
        self.height = height
        data = Array<T?>(repeating:nil, count: width * height)
    }
    
    subscript(row: Int, col: Int) -> T? {
        get {
            guard case (0..<length) = row * col,
                case (0..<width) = col,
                case (0..<height) = row
                else { return nil }
            return data[row*width + col]
        }
        set {
            guard case (0..<length) = row * col,
                case (0..<width) = col,
                case (0..<height) = row
                else { return }
            data[row*width + col] = newValue
            
        }
    }
    
    subscript(i:Int) -> T? {
        get { return data[i] }
        set { data[i] = newValue }
    }
}

public extension String {
    func editDistance(to s: String) -> Int {
        var grid = Array2D<Int>(width: s.count+1, height: count+1)
        
        (0...count).forEach{ grid[$0, 0] = $0 }
        (0...s.count).forEach{ grid[0, $0] = $0 }
        
        for i in 1...count {
            for j in 1...s.count {
                if let x = grid[i, j-1],
                    let y = grid[i-1, j],
                    let z = grid[i-1, j-1]
                {
                    grid[i, j] = Swift.min(x+1, y+1, z + (self[i-1] == s[j-1] ? 0 : 1))
                }
            }
        }
        
        return grid.last!
    }
}

//diclist = list veriable, with read korean dic
//word = korean word
//source = source that user write
//output = if distence < 4 then append to output list
func generateWords(source: String) {
    for word in AppDelegate.global.dicList {
        var newList = [String]()
        if source.editDistance(to: word) < 4{
            newList.append(word)
            DetailViewController.global.recommendList = newList
        }
    }
}




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
    
    
    struct global {
        static var recommendList = [String]()
    }

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
                generateWords(source: text)
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
//        generateWords()
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
    
    
//
//    func generateWords() {
//        recommend.append("하와이")
//        recommend.append("쌈마이")
//        recommend.append("Shine my")
//        recommend.append("카와이")
//        recommend.append("까나리")
//        recommend.append("나와이")
//        recommend.append("Find mine")
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return global.recommendList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendWord", for: indexPath) as! RecommendCollectionViewCell
        cell.recommendWord.text = global.recommendList[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(global.recommendList[indexPath.row])
        var text = self.noteContent.text
        text = text! + global.recommendList[indexPath.row]
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
