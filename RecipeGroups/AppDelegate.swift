//
//  AppDelegate.swift
//  RecipeGroups
//
//  Created by Ryan MORGAN on 5/12/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Add cache to the app
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let temporaryDirectory = NSTemporaryDirectory()
        let urlCache = URLCache(memoryCapacity: 25_000_000, diskCapacity: 50_000_000, diskPath: temporaryDirectory)
        URLCache.shared = urlCache
        
        return true
    }
    
    // Add state restoration
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    // Add state restoration
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    // Add state restoration
    // If the user was saved during state restoration, load the user
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        if RecipeController.shared.recipes.count == 0 {
            print("test")
            
            RecipeController.shared.loadSavedRecipes()
            RecipeController.shared.loadLikedRecipes()
            
            // Load liked recipes
            for recipe in RecipeController.shared.likedRecipes {
                RecipeController.shared.recipes.append(recipe)
            }
            
            // Load saved recipes
            for recipe in RecipeController.shared.savedRecipes {
                RecipeController.shared.recipes.append(recipe)
            }
            
            NotificationCenter.default.post(name: RecipeController.recipeDataUpdatedNotification, object: nil)
        }
        
        if let user = UserController.shared.loadUser() {
            UserController.shared.updateUser(name: user.name, email: user.email)
        }
        
        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       UserController.shared.saveUser()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
    }

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "RecipeGroups")
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

