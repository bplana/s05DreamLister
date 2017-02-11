//
//  MainVC.swift
//  s05DreamLister
//
//  Created by bernadette on 2/10/17.
//  Copyright © 2017 Bernadette P. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
// add protocols: UITableViewDelegate, UITableViewDataSource
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    
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
    
}

