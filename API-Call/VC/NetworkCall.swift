import Foundation

class NetworkCall
{
    var postData: [String: Any] = [:]
    var serviceUrl : URL!
    var request : URLRequest!
    
    func postDataAndPutData(methodPerformed : String, messagePassed : Message, completion: @escaping (Message?) -> Void)
    {
        var messagePassed = messagePassed
        
        if methodPerformed == "POST"
        {
            serviceUrl = URL(string: "https://www.zohoapis.com/books/v3/items?organization_id=863010973")
            request = URLRequest(url: serviceUrl)
            request.httpMethod = "POST"
        }
        else
        {
            serviceUrl = URL(string: "https://www.zohoapis.com/books/v3/items/\(messagePassed.item_id)?organization_id=863010973")
            request = URLRequest(url: serviceUrl)
            request.httpMethod = "PUT"
        }
        
        postData["name"] = messagePassed.name
        postData["sku"] = messagePassed.sku
        postData["rate"] = messagePassed.rate
        postData["purchase_rate"] = messagePassed.purchase_rate
        postData["description"] = messagePassed.description
        
        guard let jsonData = try? JSONSerialization.data(
            withJSONObject: postData,
            options: []) else
        {
            print("Error: Unable to serialize JSON");
            fatalError()
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Zoho-oauthtoken 1000.6e97fe7e12e7a8a59ef500d84a2d0de6.0c9866979fd22fa6a3bcccd36df78730", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            if let error = error
            {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse
            {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
            
            if let data = data
            {
                do
                {
                    let responseObject = try JSONSerialization.jsonObject(
                        with: data,
                        options: .mutableContainers) as? [String : Any]
                    
                    let jsonResponse = responseObject?["item"] as! [String: Any]
                    
                    var item_id = jsonResponse["item_id"] as! String
                    
                    messagePassed.item_id = item_id
                    
                    completion(messagePassed)
                }
                catch
                {
                    print("Error parsing response JSON: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func deleteData(itemIDPassed : Int)
    {
        let serviceUrl = URL(string: "https://www.zohoapis.com/books/v3/items/\(itemIDPassed)?organization_id=863010973")!
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "DELETE"
        request.addValue("Zoho-oauthtoken 1000.6e97fe7e12e7a8a59ef500d84a2d0de6.0c9866979fd22fa6a3bcccd36df78730", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            if let error = error
            {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse
            {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
            
            if let data = data
            {
                do
                {
                    let responseObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any]
                }
                catch
                {
                    print("Error parsing response JSON: \(error)")
                }
            }
        }
        task.resume()
    }
}
