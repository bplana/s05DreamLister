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
        
//        generateTestData()
        attemptFetch()
        
    }

    
    // add required methods (func) for UITableViewDelegate, UITableViewDataSource
    // numberOfRowsInSection, numberOfSections, cellForRowAt indexPath
    
    // for now: "return UITableViewCell()"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)  // created configureCell func first, below
        
        return cell
    }
    
    // secondary configure cell func (primary in ItemCell.swift)
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
        
    }
    
    // for editing an item - when an item is selected
    // didSelectRowAt indexPath -- when someone clicks on an item in the tableView, this func is called
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // make sure that there are objects in the result controller, and if there at least one of them
        // "," used to be "where" (new syntax)
        if let objs = controller.fetchedObjects , objs.count > 0 {
            
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    // get ready to do the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    

    // for now: "return 0"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    // for now: "return 0"
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
    }
    
    // for cell height
    // type in to bring up auto complete... 'heightForRowAt'
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150  // checked height in storyboard
    }
    
    
    // once we have data in our database, we need a way to fetch it & display it
    func attemptFetch() {
        
        // create fetchRequest var & telling it what to fetch
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        // how to sort the data that it's fetching
        // 'dateSort' - remember in storyboard, we can sort by Newest
        // key 'created' - an Attribute within the Item Entity (see .xcdatamodeld file)
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        
        // sort by price, title
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        // check with sort segment is selected
        if segment.selectedSegmentIndex == 0 {      // default is 0
            
            fetchRequest.sortDescriptors = [dateSort]
            
        } else if segment.selectedSegmentIndex == 1 {
            
            fetchRequest.sortDescriptors = [priceSort]
            
        } else if segment.selectedSegmentIndex == 2 {
            
            fetchRequest.sortDescriptors = [titleSort]  // NOTE: case sensitive, uppercase shows first
        }
        
        
        
        // instatiate the fetchResultController
        // note:  create shortcuts in AppDelegate.swift file, for 'managedObjectContext' ("context" shortcut)
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        // fetch request
        do {
            
            try controller.performFetch()
            
        } catch {
            
            let error = error as NSError
            print("\(error)")
            
        }
        
    }
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        
        attemptFetch()
        tableView.reloadData()
    }
    
    
    // whenever the tableView is about to update, this will start to listen for changes, & will handle that for you
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
    }
    
    // type in to bring up auto complete... "didChange anObject"
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
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath) // added after configureCell func was created
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
    
    func generateTestData() {
        
        let item = Item(context: context)
        item.title = "MacBook Pro"
        item.price = 1800
        item.details = "I can't wait until the September event, I hope they release new MBPs."
        
        let item2 = Item(context: context)
        item2.title = "Bose Headphones"
        item2.price = 300
        item2.details = "But man, it's so nice to be able to block out everyone with the noise-cancelling tech."
        
        let item3 = Item(context: context)
        item3.title = "Tesla Model S"
        item3.price = 110000
        item3.details = "Oh man this is a beautiful car. And one day I will own it."
        
        ad.saveContext()
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}








