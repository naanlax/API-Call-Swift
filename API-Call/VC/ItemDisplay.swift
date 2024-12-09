import UIKit

class ItemDisplay : UITableViewController, UISearchBarDelegate, ItemCreationDelegate
{
    var networkCall = NetworkCall()
    
    var itemDisplayed : [Message] = []
    
    let customCell = CustomCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        tableView.reloadData()
    }
    
    func displayItem(itemToBeDisplayed: Message) {
        itemDisplayed.append(itemToBeDisplayed)
        DispatchQueue.main.async
        {
            self.tableView.reloadData()
        }
    }
    
    func updateItem(itemToBeDisplayed : Message, itemId : String)
    {
        if itemToBeDisplayed.item_id == itemId
        {
            if let index = itemDisplayed.firstIndex(where: { $0.item_id == itemId }){
                itemDisplayed[index] = Message(name: itemToBeDisplayed.name,
                                               rate: itemToBeDisplayed.rate,
                                               description: itemToBeDisplayed.description,
                                               sku: itemToBeDisplayed.sku,
                                               purchase_rate: itemToBeDisplayed.purchase_rate)
            }
            DispatchQueue.main.async
            {
                self.tableView.reloadData()
            }
        }
    }
    
    func setUpUI()
    {
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cellId")
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .systemBackground
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemDisplayed.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? CustomCell else {
            fatalError("Unable to dequeue CustomTableViewCell")
        }
        
        let item = itemDisplayed[indexPath.row]
        cell.configure(item: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(
            style: .destructive, title: "Delete"
        ) {
            (action, view, completionhandler) in
            let itemToRemove = self.itemDisplayed[indexPath.row]
            self.networkCall.deleteData(itemIDPassed: Int(itemToRemove.item_id)!)
            if let index = self.itemDisplayed.firstIndex(where: { $0.sku == itemToRemove.sku })
            {
                self.itemDisplayed.remove(at: index)
                tableView.reloadData()
            }
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [action])
        
        return swipeAction
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let action = UIContextualAction(
            style: .normal, title: "Edit"
        ) {
            (action, view, completionhandler) in
            let itemToEdit = self.itemDisplayed[indexPath.row]
            
            let itemCreationVC = ItemCreation()
            itemCreationVC.itemToUpdate = itemToEdit
            itemCreationVC.name.text = itemToEdit.name
            itemCreationVC.rate.text = String(itemToEdit.rate)
            itemCreationVC.purchase_rate.text = String(itemToEdit.purchase_rate)
            itemCreationVC.sku.text = itemToEdit.sku
            itemCreationVC.desc.text = itemToEdit.description
            itemCreationVC.delegate = self
            
            self.present(itemCreationVC,
                    animated: true,
                    completion: nil)
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [action])
        
        return swipeAction
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerLabel = UILabel()
        headerLabel.text = "ITEMS"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        let headerSearchBar = UISearchBar()
        headerSearchBar.searchBarStyle = .minimal
        headerSearchBar.delegate = self
        headerSearchBar.placeholder = "Search for the item"
        headerSearchBar.sizeToFit()
        headerSearchBar.isTranslucent = true
        
        let stackForHeader = UIStackView(arrangedSubviews: [headerLabel, headerSearchBar])
        stackForHeader.axis = .vertical
        stackForHeader.spacing = 10
        stackForHeader.alignment = .fill
        stackForHeader.distribution = .fillProportionally
        stackForHeader.translatesAutoresizingMaskIntoConstraints = false
        
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        headerView.addSubview(stackForHeader)
        
        NSLayoutConstraint.activate([
            stackForHeader.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            stackForHeader.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            stackForHeader.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            stackForHeader.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10)
        ])
        
        return headerView
    }
}
