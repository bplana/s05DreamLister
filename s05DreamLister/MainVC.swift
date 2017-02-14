//
//  MainVC.swift
//  s05DreamLister
//
//  Created by bernadette on 2/10/17.
//  Copyright © 2017 Bernadette P. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
// add protocols:  UITableViewDelegate, UITableViewDataSource
// add protocol:  NSFetchedResultsControllerDelegate
    //  -  works with CoreData & your tableView to make it a lot easier to work with the fetched results that come back when you do a fetch request
    //  -  efficiently collects all the info about the results w/o the need to bring all of the results into memory at the same time
    //  -  tailored to work in conjucntion with views that present collections of objects, like your tableView or collectionViews, and these views typically expect their data source to present results as a list of sections made up of rows
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    // fetched results controller
    var controller: NSFetchedResultsController<Item>! // tell the FRC what kind of entity/data classes it will be working with (Item)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set delegate & dataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }

    
    // add required methods (func) for UITableViewDelegate, UITableViewDataSource
    // numberOfRowsInSection, numberOfSections, cellForRowAt indexPath
    
    // for now: "return UITableViewCell()"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }

    // for now: "return 0"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    // for now: "return 0"
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    // once we have data in our database, we need a way to fetch it & display it
    func attemptFetch() {
        
        // create fetchRequest var & telling it what to fetch
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        // how to sort the data that it's fetching
        // 'dateSort' - remember in storyboard, we can sort by Newest
        // key 'created' - an Attribute within the Item Entity (see .xcdatamodeld file)
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        
        fetchRequest.sortDescriptors = [dateSort]
        
        // instatiate the fetchResultController
        // note:  create shortcuts in AppDelegate.swift file, for 'managedObjectContext' ("context" shortcut)
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        // fetch request
        do {
            
            try controller.performFetch()
            
        } catch {
            
            let error = error as NSError
            print("\(error)")
            
        }
        
    }
    
    // whenever the tableView is about to update, this will start to listen for changes, & will handle that for you
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
    }
    
    // type in to bring up autoComplete... "didChange anObject"
    // command+click 'NSFetchedResultsChangeType' to see what kind of changes (insert, delete, move, update)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
            
        case.insert:
            // when you create a new item
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
            break
            
        case.delete:
            if let indexPath = indexPath { // the existing one that user has added
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            break
            
        case.update:
            // to update an existing item
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                // update the cell data (later)
            }
            
            break
            
        case.move:
            // drag/move item
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}








