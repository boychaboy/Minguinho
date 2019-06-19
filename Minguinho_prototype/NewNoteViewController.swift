//
//  NewNoteViewController.swift
//  Minguinho_prototype
//
//  Created by Eric Jeong on 06/06/2019.
//  Copyright © 2019 boychaboy. All rights reserved.
//

import UIKit
import Marklight

//diclist = list veriable, with read korean dic
//word = korean word
//source = source that user write
//output = if distence < 4 then append to output list
public func generateWords2(source: String, index: Int, word_len: Int) {
    NewNoteViewController.global.recommendList = [String]()
    var iter = 0
    if(word_len==0){//english
        var i = 1
        while (iter<30){
            for word in AppDelegate.global.dicList0{
                if source.editDistance(to: word) == i{
                    iter = iter + 1
                    NewNoteViewController.global.recommendList.append(word)
                }
                if(iter>30){
                    break
                }
            }
            i += 1
            if(i>3){
                break;
            }
        }
    }
    if(word_len==1){
        var i = 1
        while (iter<30){
            for word in AppDelegate.global.dicList11[index]{
                if source.editDistance(to: word) == i{
                    iter = iter + 1
                    NewNoteViewController.global.recommendList.append(word)
                }
                if(iter>30){
                    break
                }
            }
            i += 1
            if(i>3){
                break;
            }
        }
    }
    if(word_len==2){
        var i = 1
        while(iter<30){
            for word in AppDelegate.global.dicList22[index]{
                if source.editDistance(to: word) == i{
                    iter = iter + 1
                    NewNoteViewController.global.recommendList.append(word)
                }
                if(iter>30){
                    break
                }
            }
            i += 1
            if(i>3){
                break;
            }
        }
        print(iter)
    }
    if(word_len==3){
        var i = 1
        while (iter<30){
            for word in AppDelegate.global.dicList33[index]{
                if source.editDistance(to: word) == i{
                    iter = iter + 1
                    NewNoteViewController.global.recommendList.append(word)
                }
                if(iter>30){
                    break
                }
            }
            i += 1
            if(i>3){
                break;
            }
        }
    }
    if(word_len==4){
        var i = 1
        var index2 = index
        var flag = false
        var all_flag = false
        while (iter<30){
            for word in AppDelegate.global.dicList44[index2]{
                if source.editDistance(to: word) == i{
                    iter = iter + 1
                    NewNoteViewController.global.recommendList.append(word)
//                    print(word)
                }
                if(iter>30){
                    break
                }
            }
            i += 1
            if(i>3){
                if(flag){
                    index2 = index2 - 343
                    if(index2<0){
                        all_flag = true
                    }
                }
                else{
                    index2 = index2 + 343
                }
                if(index2 > 2401){
                    index2 = index
                    index2 = index2 - 343
                    flag = true
                    if(index2<0){
                        all_flag = true
                    }
                }
                i = 1
            }
            if(all_flag){
                break
            }
        }
    }
}

class NewNoteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteAlbum: UITextField!
    @IBOutlet weak var noteContent: UITextView!
    
    @IBOutlet weak var recommendView: UICollectionView!
    
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    var dicList = [[String]]()
    
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
    
    struct global {
        static var recommendList = [String]()
    }

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
    override func viewDidAppear(_ animated: Bool) {
        self.noteContent.addObserver(self, forKeyPath: "selectedTextRange", options: NSKeyValueObservingOptions(rawValue: NSKeyValueObservingOptions.new.rawValue|NSKeyValueObservingOptions.old.rawValue), context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if((keyPath == "selectedTextRange")){
            if let text = wordBeforeCursor(){
                //                generateWords(source: text)
                getRhyme(source: text)
                recommendView.reloadData()
            }
            else{
            }
        }
    }
    
    func getRhyme(source : String) {
        var strlen = source.count
        var moum = [Int]()
        var moum_class = [Int]()
        var index = Int()
        var en_flag = false
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        for char in source.unicodeScalars {
            if characterset.contains(char) {
                en_flag = true
            }
        }
        if(en_flag==false){//korean rhyme
//            print("Korean")
            for i in 0..<strlen {
                let index = source.index(source.startIndex, offsetBy: i)
                moum.append(getMoum(source : source[index]))
                moum_class.append(getMoumClass(m : moum[i]))
            }
            if(strlen == 1){//한글자 라임
                index = moum_class[0]
            }
            else if(strlen == 2){//두글자 라임
                index = 7*moum_class[0] + moum_class[1]
            }
            else if(strlen == 3){//세글자 라임
                index = 49*moum_class[0] + 7*moum_class[1] + moum_class[2]
            }
            else if(strlen == 4){//네글자 라임
                index = 343*moum_class[0] + 49*moum_class[1] + 7*moum_class[2] + moum_class[3]
            }
            else{
                print("다섯글자는 지원하지 않습니다")
                index = 0
            }
        }
        else{
            index = 0
            strlen = 0
        }
        generateWords2(source: source, index: index, word_len: strlen)
        return
    }
    
    func getMoumClass(m : Int) -> Int {
        var c = 0
        if(m==0 || m==2 || m==9){
            c = 0
        }
        else if(m==1 || m==3 || m==3 || m==5 || m==7 || m==10 || m==11 || m==15){
            c = 1
        }
        else if(m==4 || m==6 || m==14){
            c = 2
        }
        else if(m==8 || m==12){
            c = 3
        }
        else if(m==13 || m==17){
            c = 4
        }
        else if(m==18){
            c = 5
        }
        else if(m==16 || m==19 || m==20){
            c = 6
        }
        return c
    }
    
    func getMoum(source : Character) -> Int {
        let val = UnicodeScalar(String(source))?.value
        guard let value = val else { return 0 }
        //        let x = (value - 0xac00) / 28 / 21
        let y = ((value - 0xac00) / 28) % 21
        //        let z = (value - 0xac00) % 28
        
        return Int(y)
    }

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
        noteContent.inputAccessoryView = recommendView
        
//        noteContent.inputAccessoryView = recommendView
//        dicList = AppDelegate.global.dicList
//debug print(dicList[1000])
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
        return global.recommendList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendWord2", for: indexPath) as! RecommendCollectionViewCell
        cell.recommendWord2.text = global.recommendList[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(recommend[indexPath.row])
        var text = self.noteContent.text
        text = text! + global.recommendList[indexPath.row]
        self.noteContent.text = text
        return
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
