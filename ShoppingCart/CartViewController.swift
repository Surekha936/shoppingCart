//
//  CartViewController.swift
//  ShoppingCart
//
//  Created by Encoding on 06/11/17.
//  Copyright © 2017 surekha Ramchandra Shinde. All rights reserved.
//

import UIKit
import CoreData
class CustomTableViewCell: UITableViewCell
{
    @IBOutlet weak var imageVIewProduct: UIImageView!
    
    @IBOutlet weak var label_ProductName: CustomLabel!
    
    @IBOutlet weak var label_VendorName: CustomLabel!
    
    @IBOutlet weak var label_VendorAddress: CustomLabel!
    
    @IBOutlet weak var label_Price: CustomLabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var label_PriceValue: CustomLabel!
    
    @IBOutlet weak var button_CallVendor: UIButton!
    
    
    @IBOutlet weak var button_RemoveFromCart: UIButton!
    
}
class CartViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var productsArray: [NSManagedObject] = []
    let cart = CartAPI()
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        tableView.register(CustomTableViewCell.self,
//                           forCellReuseIdentifier: "Cell")
// tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        self.tableView.register(UITableViewCell(), forCellReuseIdentifier: "Cell")
//
        
        productsArray = cart.getCartData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func buttonCallVendorPressed(_ sender: UIButton)
    {
        
    }
    
    @IBAction func button_RemoveFromCartPressed(_ sender: UIButton)
    {
        let product = productsArray[sender.tag]
       let success = cart.removeFromCart(productId: (product.value(forKeyPath: "productID") as! String?)!)
        if success
        {
            print("removed")
            productsArray.remove(at:sender.tag)
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return productsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : CustomTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        let product = productsArray[indexPath.row]
        cell.label_ProductName.text = product.value(forKeyPath: "productName") as! String?
        cell.label_VendorName.text = product.value(forKeyPath: "vendorName") as! String?
        cell.label_VendorAddress.text = product.value(forKeyPath: "vendorAddress") as! String?
        cell.label_Price.text = "Price"
        cell.label_PriceValue.text = product.value(forKeyPath: "productPrice") as! String?
        
        if let image = (product.value(forKeyPath: "productImage") as! Data?)
        {
            cell.imageVIewProduct.image = UIImage(data:image)!
        }
        else
        {
            cell.activityIndicator.startAnimating()
            let appImageURL : NSURL = NSURL(string : (product.value(forKeyPath: "productImagePath") as! String?)!)!
            cell.imageVIewProduct.image = UIImage(named: "DummyImage");
            
            
            URLSession.shared.dataTask(with: appImageURL as URL)
            {
                data, response, error in
                do
                {
                    // Convert the downloaded data in to a UIImage object
                    guard  let image = UIImage(data: data!)
                        
                        else
                    {
                        if tableView.cellForRow(at: indexPath) != nil
                        {
                            let
                            cellToUpdate : CustomTableViewCell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
                            cellToUpdate.activityIndicator.stopAnimating()
                        }
                        return;
                    }
                    // Update the cell
                    DispatchQueue.main.async
                        {
                            if tableView.cellForRow(at: indexPath) != nil
                            {
                              let  cellToUpdate : CustomTableViewCell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
                                cellToUpdate.imageVIewProduct.image = image;
                                cellToUpdate.activityIndicator.stopAnimating()
                            }
                    }
                }
                
                }.resume()
        }
       
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }

   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
