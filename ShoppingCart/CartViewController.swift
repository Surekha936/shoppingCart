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
    @IBOutlet weak var view_Container: UIView!
    @IBOutlet weak var button_CallVendor: UIButton!
    @IBOutlet weak var button_RemoveFromCart: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        button_CallVendor.layer.borderColor = UIColor.lightGray.cgColor
        button_RemoveFromCart.layer.borderColor = UIColor.lightGray.cgColor
        view_Container.layer.borderColor = UIColor.lightGray.cgColor
        button_CallVendor.layer.borderWidth = 1.0
        view_Container.layer.borderWidth = 1.0
         view_Container.layer.cornerRadius = 4.0
        button_RemoveFromCart.layer.borderWidth = 1.0
    }
}
class CartViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var label_TotalPrice: UILabel!
    
    var productsArray: [NSManagedObject] = []
    let cart = CartAPI()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        tableView.backgroundColor = UIColor.white

//        tableView.register(CustomTableViewCell.self,
//                           forCellReuseIdentifier: "Cell")
// tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        self.tableView.register(UITableViewCell(), forCellReuseIdentifier: "Cell")
//
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.automaticallyAdjustsScrollViewInsets = false;
        self.tableView.contentInset = UIEdgeInsets.zero;
        self.tableView.scrollIndicatorInsets = UIEdgeInsets.zero;
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);

      
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
          productsArray = cart.getCartData()
        
        if let sum = (productsArray as NSArray).value(forKeyPath:"@sum.productPrice") as? Double
        {
          label_TotalPrice.text = "Total Price : \(sum)"
        }

        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func buttonCallVendorPressed(_ sender: UIButton)
    {
         let product = productsArray[sender.tag]
        if product.value(forKeyPath: "phoneNumber") != nil
        {
            let phoneNumber : String = product.value(forKeyPath: "phoneNumber") as! String
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
            
        }
    }
    
    @IBAction func button_RemoveFromCartPressed(_ sender: UIButton)
    {
        let product = productsArray[sender.tag]
       let success = cart.removeFromCart(productId: (product.value(forKeyPath: "productID") as! String?)!)
        if success
        {
//            print("removed")
            let alert = UIAlertController(title: "Alert", message: "Removed from cart", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
            // change to desired number of seconds (in this case 5 seconds)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                alert.dismiss(animated: true, completion: nil)
            }
            productsArray.remove(at:sender.tag)
            tableView.reloadData()
            if let sum = (productsArray as NSArray).value(forKeyPath:"@sum.productPrice") as? Double
            {
                label_TotalPrice.text = "Total Price : \(sum)"
            }

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
        cell.button_CallVendor.tag = indexPath.row
        cell.button_RemoveFromCart.tag = indexPath.row

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
       
       cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
   
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 1.0
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
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
