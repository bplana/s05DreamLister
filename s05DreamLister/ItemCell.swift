//
//  ItemCell.swift
//  s05DreamLister
//
//  Created by bernadette on 2/10/17.
//  Copyright © 2017 Bernadette P. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var itemType: UILabel!       // ~~~EXERCISE~~~
    
    // primary configure cell func
    func configureCell(item: Item) {
        
        title.text = item.title     // 'title' attribute in Item entity
        price.text = "$\(item.price)"
        details.text = item.details
        thumb.image = item.toImage?.image as? UIImage
        
        if item.toItemType?.type != nil && item.toItemType?.type != "" {               // ~~~EXERCISE~~~
            itemType.text = item.toItemType?.type
        } else {
            itemType.text = "Other"
        }
    }
    
    

}
