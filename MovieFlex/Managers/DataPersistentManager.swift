//
//  DataPersistentManager.swift
//  MovieFlex
//
//  Created by Warln on 24/03/22.
//


import UIKit
import CoreData


class DataPersistentManager {
    static let shared = DataPersistentManager()
    
    enum DataBaseError: Error{
        case failedToDownload
        case failedToFetch
        case failedToDelete
    }
    
    func downloadTitleWith(with model: Title, completion: @escaping (Result<Void,Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let item = TitleItem(context: context)
        item.id = Int64(model.id ?? 0)
        item.overview = model.overview
        item.title = model.title
        item.original_title = model.original_title
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.video = model.video ?? false
        item.vote_average = model.vote_average ?? 0.0
        item.popularity = model.popularity ?? 0
        item.media_type = model.media_type
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DataBaseError.failedToDownload))
        }
        
    }
    
    func fetchTitlesFromDatabase(completion: @escaping (Result<[TitleItem],Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        do{
            let titles = try context.fetch(request)
            completion(.success(titles))
        }catch{
            completion(.failure(DataBaseError.failedToFetch))
        }
        
    }
    
    func deleteTitleFromDatabase(with model: TitleItem, completion: @escaping (Result<Void,Error>) -> Void) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appdelegate.persistentContainer.viewContext
        context.delete(model)
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DataBaseError.failedToDelete))
        }
    }
    
}
