//
//  MajorSelectionVC.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/21/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit

//Protocol for transfering data back to presentingVC after this VC is dismissed
protocol PopUpSenderDelegate: class{
    func dataTransfer(majors: [PopUpSelectionData])
}


class MajorSelectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //MARK: Properties
    var presentingVC: UIViewController!
    var dataToDisplay: [String]!
    var selectionsToDisplay = [PopUpSelectionData]()
    var selectedMajors = [PopUpSelectionData]()
    var majors = [String]()
    weak var delegate: PopUpSenderDelegate?

    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        rootView.layer.cornerRadius = 15.0
        rootView.layer.masksToBounds = true
        
        convertStringToSelectionData()
    }
    
    @IBOutlet var rootView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBAction func submitButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: {
            for major in self.selectionsToDisplay{
                if major.selected == true{
                    self.selectedMajors.append(major)
                }
            }
            
            self.delegate?.dataTransfer(majors: self.selectedMajors)
        })
    }
  
    func convertStringToSelectionData(){
        for item in dataToDisplay{
            let selection = PopUpSelectionData(title: item, selected: false)
            selectionsToDisplay.append(selection)
        }
    }
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopUpSelectionCell", for: indexPath) as! PopUpSelectionCell
        cell.configureCell(data: selectionsToDisplay[indexPath.row].title, selected: selectionsToDisplay[indexPath.row].selected)
        cell.tapAction = {(cell) in
            if self.selectionsToDisplay[indexPath.row].selected == false{
                self.selectionsToDisplay[indexPath.row].selected = true
            }else{
                self.selectionsToDisplay[indexPath.row].selected = false

            }
            tableView.reloadData()
        }
        
        return cell
    }
    
    //MARK: Close
    override func viewWillDisappear(_ animated: Bool) {
        removeView()
    }
    
    func removeView(){
        for subview in self.presentingVC.view.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    
    
}
