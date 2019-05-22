//
//  ListyTableViewController.swift
//  Listy
//
//  Created by Kunal Pawar on 11/5/19.
//  Copyright © 2019 Kunal Pawar. All rights reserved.
//

import UIKit

class ListyTableViewController: UITableViewController, UISearchBarDelegate, ListyTableCellDelegate {
    
    @IBOutlet weak var btnSortCharacter: UIButton!
    @IBOutlet weak var btnSortActor: UIButton!
    @IBOutlet weak var txtSearchBar: UISearchBar!
    
    var listItems:[CastMember]! // Holds the list to be displayed
    var mainList:[CastMember]!  // Holds the full list
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        initView()
        initData()
    }
    
    
    /// Handler for click event on sort character button
    @IBAction func onClickBtnSortCharacter(_ sender: UIButton) {
        sortByCharacter()
    }
    
    
    /// Handler for click event on sort actor button
    @IBAction func onClickBtnSortActor(_ sender: UIButton) {
        sortByAge()
    }
    
    
    /// Initializes the UI elements of the view
    func initView() {
        btnSortCharacter.layer.cornerRadius = 8
        btnSortActor.layer.cornerRadius = 8
    }
    
    
    /// Copies file to documents directory and loads data from the file
    func initData() {
        listItems = [CastMember]()
        
        if(!DataManager.fileExistsInDocumentDir()) {
            DataManager.copyFileToDocuments()
        }
        
        loadData()
    }
    
    /// Loads the data into the main list and display list
    func loadData() {
        mainList = DataManager.loadData()
        listItems = mainList
        tableView.reloadData();
    }

    /// Save data to the file
    func addNewMember(castMember:CastMember) {
        mainList.append(castMember)
        
        // If the file is saved successfully
        // Update the list with new member
        if(DataManager.saveData(list: mainList)) {
            listItems = mainList
            
            // Add new cell at the bottom of the table
            let indexPath = IndexPath(row: tableView.numberOfRows(inSection: 0), section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    func deleteMember(at indexPath:IndexPath) {
        mainList.remove(at: indexPath.row)
        
        // Save the new list to the file
        if(DataManager.saveData(list: mainList)) {
            listItems = mainList
            
            // Remove the cell from the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    /// Sorts the list by the character property
    /// Sorts the mainList first and re-assigns it to
    /// listItems to prevent issues when deleting
    func sortByCharacter() {
        mainList.sort(by: {
            $0.character < $1.character
        })
        
        listItems = mainList
        tableView.reloadData()
    }
    
    
    /// Sorts the list by the actor property
    /// Sorts the mainList first and re-assigns it to
    /// listItems to prevent issues when deleting
    func sortByAge() {
        mainList.sort(by : {
            $0.age < $1.age
        })
        
        listItems = mainList
        tableView.reloadData()
    }
    
    
    /// Add button action
    @IBAction func addNewMember(_ sender: UIBarButtonItem) {
        let alertBox = UIAlertController(title: "Add Member", message: "Enter member details", preferredStyle: .alert)
        
        alertBox.addTextField {(textField: UITextField) in
            textField.placeholder = "Actor Name"
        }
        
        alertBox.addTextField {(textField: UITextField) in
            textField.placeholder = "Character Name"
        }
        
        alertBox.addTextField {(textField: UITextField) in
            textField.placeholder = "Age"
        }
        
        // Add button action in UI Alert
        alertBox.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action:UIAlertAction) in
            guard let actor = alertBox.textFields?[0].text else {return}
            guard let character = alertBox.textFields?[1].text else {return}
            guard let age = alertBox.textFields?[2].text else {return}
            
            // Check for empty values (because guard doesn't)
            if(actor.isEmpty || character.isEmpty || age.isEmpty) {
                return
            }
            
            // Create a new CastMember instance using the above values
            let newMember = CastMember.init(actor: actor, character: character, age: Int(age)!)
            self.addNewMember(castMember: newMember) // Add the new member to the list
        }))
        
        alertBox.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertBox, animated: true, completion: nil)
    }
    
    
    /// Implementation of the delegate method
    func doDelete(_ cell: ListyTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            deleteMember(at: indexPath)
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListyTableViewCell

        // Assign this controller as delegate for the cell
        cell.delegate = self
        
        // Configure the cell
        let listItem = listItems[indexPath.row]
        
        cell.lblCharacter.text = listItem.character
        cell.lblActor.text = listItem.actor
        cell.lblAge.text = String(listItem.age)

        return cell
    }
    
    
    // Search Bar functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Reset the table if search text is deleted
        guard !searchText.isEmpty else {
            
            listItems = mainList
            tableView.reloadData()
            return
        }
        
        // Filter the display list according to search text
        listItems = mainList.filter({ castMember -> Bool in
            return castMember.character.contains(searchText)
        })
        tableView.reloadData()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
