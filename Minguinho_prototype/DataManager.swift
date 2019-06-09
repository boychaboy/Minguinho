//
//  DataManager.swift
//  Minguinho_prototype
//
//  Created by Eric Jeong on 06/06/2019.
//  Copyright © 2019 boychaboy. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    
    static let shared = DataManager()
    private init() { }
    
    var mainContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    var noteList = [Note]()
    var albumList = [Album]()
    
    func fetchNote() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        
        let sortByDateDesc = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        do {
            noteList = try mainContext.fetch(request)
        }
        catch{
            print(error)
        }
    }
    
    func fetchAlbum() {
        let request: NSFetchRequest<Album> = Album.fetchRequest()
        
        let sortByDateDesc = NSSortDescriptor(key: "albumDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        do {
            albumList = try mainContext.fetch(request)
        }
        catch{
            print(error)
        }
    }
    
    func searchEntityByKey(_ entity : String, _ key : String, _ val : String) -> Bool {
        let managedContext = DataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        var flag: Bool = false
        do{
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                if let text = (data.value(forKey: key)){
                    let text2 = text as! String
                    if text2 == val{
                        flag = true
                    }
                }
            }
        }
        catch {
            print("Failed")
        }
        return flag
    }
    
    
    func addNewNote(_ title: String?, _ album: String?, _ content: String?) {
        let newNote = Note(context: mainContext)
        newNote.title = title
        newNote.album = album
        newNote.content = content
        newNote.date = Date()
        saveContext()
    }
    
    func addNewAlbum(_ title: String?, _ image: Data!){
        let newAlbum = Album(context: mainContext)
        newAlbum.albumName = title
        newAlbum.albumImage = image
        newAlbum.albumDate = Date()
        saveContext()
    }
    
    
    
    func deleteNote(_ note: Note?){
        if let note = note {
            mainContext.delete(note)
            saveContext()
        }
    }
    
    func deleteAlbum(_ album: Album?){
        if let album = album {
            mainContext.delete(album)
            saveContext()
        }
    }

    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Minguinho_prototype")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
