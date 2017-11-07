		//
//  ProductsCollectionViewController.swift
//  ShoppingCart
//
//  Created by surekha Ramchandra Shinde on 05/11/2017.
//  Copyright © 2017 surekha Ramchandra Shinde. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
class MyCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var label_ProductName: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var button_AddToCart: UIButton!
    
}
class ProductsCollectionViewController: UIViewController, UICollectionViewDataSource
{
    @IBOutlet var collectionView_products: UICollectionView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var array_Products = Array<NSDictionary>()
    var imageCache = [String :UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.automaticallyAdjustsScrollViewInsets = false;
    
//        self.loadProducts()
    }

    @IBAction func AddToCartPressed(_ sender: UIButton)
    {
        print("pressed button")
        var productDict = array_Products[sender.tag]
        let cell : MyCollectionViewCell = collectionView_products.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as! MyCollectionViewCell
        if cell.imageOne.image != nil
        {
            let image = UIImagePNGRepresentation(cell.imageOne.image!) as NSData?
            productDict.setValue(image, forKey: "productImage")
        }
        let cart = CartAPI()
        cart.save(productDict: array_Products[sender.tag]);
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadProducts()
    {
        let internetAvalilable = InternetConnectionService()
        if internetAvalilable.checkFornetConnectionWithStatus()
        {
             activityIndicator.startAnimating()
            let api = ProductsAPI()
            api .getProducts(completion:
                {
                    productsArray in
                    self.activityIndicator.stopAnimating()
                    self.array_Products = productsArray as! Array<NSDictionary>
                    self.collectionView_products.reloadData()
            })
        }
        else
        {
            let alert  = UIAlertController(title: "No Internet Connection!", message: "Please check your internet connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: false, completion: nil)

        }
       
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return array_Products.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! MyCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        if    let appDict : NSDictionary =  array_Products[indexPath.row] as? NSDictionary
        {
            cell.label_ProductName.text =  appDict["productname"] as? String
           cell.button_AddToCart.tag = indexPath.row
            let imageStr = appDict["productImg"] as! String
            if (imageCache[imageStr] != nil)
            {
                cell.imageOne.image = imageCache[imageStr]
            }
            else
            {
                cell.activityIndicator.startAnimating()
                let appImageURL : NSURL = NSURL(string : imageStr)!
                cell.imageOne.image = UIImage(named: "DummyImage");
                
                
                URLSession.shared.dataTask(with: appImageURL as URL)
                {
                    data, response, error in
                    do
                    {
                        // Convert the downloaded data in to a UIImage object
                     guard  let image = UIImage(data: data!)
                        
                        else
                     {
                        if collectionView.cellForItem(at: indexPath) != nil
                        {
                            let
                            cellToUpdate : MyCollectionViewCell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
                            cellToUpdate.activityIndicator.stopAnimating()
                        }
                        return;
                     }
                        // Store the image in to our cache
                        self.imageCache[imageStr] = image
                        // Update the cell
                        DispatchQueue.main.async
                            {
                                if collectionView.cellForItem(at: indexPath) != nil
                                {
                                    let    cellToUpdate : MyCollectionViewCell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
                                    cellToUpdate.imageOne.image = image;
                                    cellToUpdate.activityIndicator.stopAnimating()
                                }
                        }
                    }
                    
                    }.resume()
            }
            
        }
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        return cell
        
    }
    
    let itemsPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 10.0)
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = (sectionInsets.left) * (itemsPerRow + 1)
        let availableWidth = UIScreen.main.bounds.size.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3 sectionInsets
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
