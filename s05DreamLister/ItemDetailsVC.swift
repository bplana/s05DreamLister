//
//  ItemDetailsVC.swift
//  s05DreamLister
//
//  Created by bernadette on 2/15/17.
//  Copyright © 2017 Bernadette P. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // add protocols:  UIPickerViewDataSource, UIPickerViewDelegate
    // add for images:  UIImagePickerControllerDelegate, UINavigationControllerDelegate
    
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumbImage: UIImageView!
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Empty ("") title for backBarButtonItem (storyboard - Add/Edit page)
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        // set delegate & dataSource for pickerView
        storePicker.delegate = self
        storePicker.dataSource = self
        
        // set delegate
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // create stores for stores array (test data)
        // entity type: Store
//        let store = Store(context: context)
//        store.name = "Best Buy"
//        let store2 = Store(context: context)
//        store2.name = "Tesla Dealership"
//        let store3 = Store(context: context)
//        store3.name = "Fry's Electronics"
//        let store4 = Store(context: context)
//        store4.name = "Target"
//        let store5 = Store(context: context)
//        store5.name = "Amazon"
//        let store6 = Store(context: context)
//        store6.name = "K Mart"
//        
//        ad.saveContext()    // save context (core data)
        getStores()     // show store list in picker
        
        if itemToEdit != nil {          // check to see whether or not we're editing (a cell / details)
            loadItemData()
        }
    
    }
    
    
    // add required methods (func) for UIPickerViewDataSource, UIPickerViewDelegate
    // titleForRow (for title), numberOfRowsInComponent, numberOfComponents (how many columns), didSelectRow
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // from the created array holding the stores to choose from
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        // create an array to hold the stores to choose from
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // update when selected
    }
    
    // to fetch results (remember to import CoreData)
    func getStores() {
        
        // create fetch request
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            
            // set the stores array = the result we get back
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
            
        } catch {
            
            // handle the error
            
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {

//        // insert an entity into the NSManagedObjectContext
//        let item = Item(context: context)

        var item: Item!     // changing/updating for new edit-item feature
        let picture = Image(context: context)       // create image entity called 'picture'
        picture.image = thumbImage.image        // assigning the image attribute of picture, to the image we have selected from the camera roll
        
        if itemToEdit == nil {
            
            // THEN we create a new item (if not from edit)
            item = Item(context: context)
            
        } else {
            
            // BUT if we did pass over an item...
            item = itemToEdit
        }

        // save image - need to create image entity
        // associate that image to our item
        item.toImage = picture
        
        // not adding to many checks here... (for example, you may want to make sure the user is entering numbers for the price field)
        
        // assign the details from the Title/Price/Details fields to the attributues of that item, then save that to the database
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue    // convert
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        
        // assign store that was selected
        // ".toStore" -- check Relationship in Item Entity, in .xcdatamodeld file
        // inComponent = row, we just have 1 row, so "0"
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        // save it
        ad.saveContext()
        
        // when Save button is pressed, go back to main View Controller
        // "_ =" --> new syntax for pop...
        _ = navigationController?.popViewController(animated: true)
        
        
    }
    
    // edit details in existing cell
    // created:  var itemToEdit
    // added to viewDidLoad:  check if editing
    func loadItemData() {
        
        if let item = itemToEdit {      // so we don't have to type 'itemToEdit' every time
            
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            // image
            thumbImage.image = item.toImage?.image as? UIImage
            
            // set picker to correct store
            if let store = item.toStore {
                
                // loop to check
                var index = 0
                repeat {
                    
                    let s = stores[index]
                    if s.name == store.name {
                        
                        // check to see if the name compares. if so, then we are going to set the row to that index
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                } while (index < stores.count)
            }
        }
        
    }

    // delete item
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        // delete item
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        // pop back to the controller
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    // for images
    @IBAction func addImage(_ sender: UIButton) {
        
        // when the image button is clicked, use camera roll to select images -- need to inform user with msg
        // need to add into info.plist --> Privacy - Photo Library Usage Description
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // need to extract actual image
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            thumbImage.image = img
        }
        
        // dismiss picker
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    

}














