//
//  MainTableViewController.swift
//  Hogwarts
//
//  Created by Kaleb  Carrizoza on 9/17/20.
//  Copyright © 2020 Kaleb  Carrizoza. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {

    //MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        HouseGuestController.sharedInstance.fetchResultsController.delegate = self

    }
    
    //MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        presentAlertController()
    }
    
    //MARK: - Helper Methods
    
    func presentAlertController() {
        let alertController = UIAlertController(title: "Add Guest", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Person name..."
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Hogwarts House.."
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    let addGuessAction = UIAlertAction(title: "add", style: .default) { (_) in
        guard let guestName = alertController.textFields?[0].text, !guestName.isEmpty,
        
            let house = alertController.textFields?[1].text, !house.isEmpty else {return}
        
        HouseGuestController.sharedInstance.createGuest(guestName: guestName, house: house)
    }
        alertController.addAction(cancelAction)
        alertController.addAction(addGuessAction)
        
        present(alertController, animated: true)
}
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        HouseGuestController.sharedInstance.fetchResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // this functions gets called for every section and then counts the number of objects 
        return HouseGuestController.sharedInstance.fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "guessCell", for: indexPath) as? HouseGuestTableViewCell else {return UITableViewCell()}
// how to put in a custom table view cell above
        
        let guest = HouseGuestController.sharedInstance.fetchResultsController.object(at: indexPath)
        
        cell.guess = guest
        cell.delegate = self

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let guestToDelete = HouseGuestController.sharedInstance.fetchResultsController.object(at: indexPath)
            HouseGuestController.sharedInstance.removeGuest(houseGuest: guestToDelete)
        }
    }
    
    //helps with constraints
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 7
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return HouseGuestController.sharedInstance.fetchResultsController.sectionIndexTitles[section] == "0" ? "Invisibility Cloak Active" : "Expose"
    }
    
}//end of class

//MARK: - Extensions
//instructions for delegate, need to grab the index path for the sections
extension MainTableViewController:HouseGuestTableViewCellDelegate {
    func houseButtonTapped(cell: HouseGuestTableViewCell) {
        guard let index = tableView.indexPath(for: cell) else {return}
        let guest = HouseGuestController.sharedInstance.fetchResultsController.object(at: index)
        HouseGuestController.sharedInstance.updateVisibility(houseGuest: guest)
        cell.updateViews()
    }
    
    
}//end of extension

extension MainTableViewController: NSFetchedResultsControllerDelegate {
    
       func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            self.tableView.beginUpdates()
        }
        
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
            
            switch type {
            case .insert:
                let indexSet = IndexSet(integer: sectionIndex)
                tableView.insertSections(indexSet, with: .automatic)
                
            case .delete:
                let indexSet = IndexSet(integer: sectionIndex)
                tableView.deleteSections(indexSet, with: .automatic)
                
            default:
                break
            }
        }
        
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            
            switch type {
            case .delete:
                guard let indexPath = indexPath else {return}
                tableView.deleteRows(at: [indexPath], with: .fade)
            case .insert:
                guard let newIndexPath = newIndexPath else {return}
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            case .move:
                guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
                tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            case .update:
                guard let indexPath = indexPath else {return}
                tableView.reloadRows(at: [indexPath], with: .automatic)
            @unknown default:
                fatalError()
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.endUpdates()
        }
    }
