import UIKit

protocol ItemCreationDelegate
{
    func displayItem(itemToBeDisplayed : Message)
    func updateItem(itemToBeDisplayed : Message, itemId : String)
}

class ItemCreation : UIViewController
{
    var networkCall = NetworkCall()
    
    var delegate : ItemCreationDelegate?
    
    var itemToUpdate : Message?
    
    var name = UITextField()
    var desc = UITextField()
    var sku = UITextField()
    var rate = UITextField()
    var purchase_rate = UITextField()
    var submit = UIButton()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "Item Creation Page"
        
        setUpUI()
    }
    
    func setUpUI()
    {
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.layer.cornerRadius = 10
        submit.setTitle("Submit", for: .normal)
        submit.backgroundColor = .systemBlue
        submit.tintColor = .black
        submit.addTarget(
            self,
            action: #selector(submitPressed),
            for: .touchUpInside
        )
        
        [name, desc, sku, rate, purchase_rate].forEach
        {
            textfield in
            textfield.translatesAutoresizingMaskIntoConstraints = false
            textfield.backgroundColor = .white
            textfield.textColor = .black
            textfield.textAlignment = .center
            textfield.layer.cornerRadius = 10
            textfield.layer.borderWidth = 0.7
            textfield.layer.borderColor = UIColor.black.cgColor
            view.addSubview(textfield)
        }
        
        name.placeholder = "Item Name"
        desc.placeholder = "Item Description"
        sku.placeholder = "Item sku"
        rate.placeholder = "Item SellingPrice"
        purchase_rate.placeholder = "Item CostPrice"
        
        let stackView = UIStackView(arrangedSubviews: [name, desc, sku, rate, purchase_rate, submit])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.layer.masksToBounds = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func submitPressed()
    {
        guard let rateText = rate.text else { return }
        let rateValue = Int(rateText) ?? 0
        
        guard let purchaseText = purchase_rate.text else { return }
        let purchaseValue = Int(purchaseText) ?? 0
        
        if itemToUpdate != nil{
            
            var message = Message(
                item_id: String(itemToUpdate?.item_id ?? ""),
                name: itemToUpdate?.name ?? "",
                rate: itemToUpdate?.rate ?? 0,
                description: itemToUpdate?.description ?? "",
                sku: itemToUpdate?.sku ?? "",
                purchase_rate: itemToUpdate?.purchase_rate ?? 0
            )
            
            networkCall.postDataAndPutData(methodPerformed : "PUT", messagePassed: message)
            { [self]
                messagePassed in
                self.delegate?.updateItem(itemToBeDisplayed: messagePassed!, itemId: messagePassed!.item_id)
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        else{
            
            var message = Message(
                item_id: "",
                name: name.text ?? "",
                rate: rateValue,
                description: desc.text ?? "",
                sku: sku.text ?? "",
                purchase_rate: purchaseValue
            )

            networkCall.postDataAndPutData(methodPerformed : "POST", messagePassed: message)
            {
                messagePassed in
                self.delegate?.displayItem(itemToBeDisplayed: messagePassed!)
            }
        }
    }
}
