//
//  AnimalsTableViewController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AnimalsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var animalNames: [String] = []
    
    let apiController = APIController()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // transition to login view if conditions require
        if apiController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animalNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = animalNames[indexPath.row]

        return cell
    }

    // MARK: - Actions
    
    @IBAction func getAnimals(_ sender: UIBarButtonItem) {
        // fetch all animals from API
        apiController.fetchAllAnimalNames { result in
            // this treats the throwable method result like an optional
            // success provies an array of strings, and failure provides a nil value
//            if let names = try? result.get() {
//                DispatchQueue.main.async {
//                    self.animalNames = names
//                    self.tableView.reloadData()
//                }
//            }
            
            do {
                let names = try result.get()
                DispatchQueue.main.async {
                    self.animalNames = names
                    self.tableView.reloadData()
                }
            } catch {
                if let error = error as? NetworkError {
                    switch error {
                        case .noAuth:
                            NSLog("No Bearer token, please log in.")
                        case .badAuth:
                            NSLog("Bearer token invalid.")
                        case .otherError:
                            NSLog("Generic netowrk error occured")
                        case .badData:
                            NSLog("Data received was invalid, corrupt, or doesnt exist")
                        case .noDecode:
                            NSLog("Animal JSON data could not be decoded")
                        default:
                            NSLog("Other error ocured")
                        
                    }
                }
            }
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            // inject dependencies
            if let destinationVC = segue.destination as? LoginViewController {
                destinationVC.apiController = apiController
            }
        } else if segue.identifier == "ShowAnimalDetailSegue" {
            if let detailVC = segue.destination as? AnimalDetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    detailVC.animalName = animalNames[indexPath.row]
                }
                detailVC.apiController = apiController
            }
        }
    }
}
