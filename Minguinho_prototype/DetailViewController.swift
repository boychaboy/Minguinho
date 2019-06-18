//
//  DetailViewController.swift
//  Minguinho_prototype
//
//  Created by Eric Jeong on 06/06/2019.
//  Copyright © 2019 boychaboy. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons


//
private extension String {
    subscript(i:Int) -> Character {
        let idx = index(startIndex, offsetBy: i)
        return self[idx]
    }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
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
func generateWords(source: String, index: Int, word_len: Int) {
    DetailViewController.global.recommendList = [String]()
    var iter = 0
    if(word_len==0){//english
        var i = 1
        while (iter<30){
            for word in AppDelegate.global.dicList0{
                if source.editDistance(to: word) == i{
                    iter = iter + 1
                    DetailViewController.global.recommendList.append(word)
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
                    DetailViewController.global.recommendList.append(word)
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
                    DetailViewController.global.recommendList.append(word)
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
                    DetailViewController.global.recommendList.append(word)
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
        while (iter<30){
            for word in AppDelegate.global.dicList44[index]{
                if source.editDistance(to: word) == i{
                    iter = iter + 1
                    DetailViewController.global.recommendList.append(word)
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
//    var dicList = [[[String]]]()
    
    struct global {
        static var recommendList = [String]()
        static var searchFlag : Bool = false
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
            print("Korean")
            for i in 0..<strlen {
                moum.append(getMoum(source : source[i]))
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
        generateWords(source: source, index: index, word_len: strlen)
        return
    }
    
    func detectedLangauge<T: StringProtocol>(_ forString: T) -> String? {
        guard let languageCode = NSLinguisticTagger.dominantLanguage(for: String(forString)) else {
            return nil
        }
        
        let detectedLangauge = Locale.current.localizedString(forIdentifier: languageCode)
        
        return detectedLangauge
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
        if (global.searchFlag == true){
            for i in 0..<DataManager.shared.noteList.count{
                if( DataManager.shared.noteList[i].title == note?.title) && (DataManager.shared.noteList[i].album == note?.album) &&
                    (DataManager.shared.noteList[i].content == note?.content)
                {
                    indexRow = i
                }
            }
            global.searchFlag = false
        }
//        dicList = AppDelegate.global.dicList
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
