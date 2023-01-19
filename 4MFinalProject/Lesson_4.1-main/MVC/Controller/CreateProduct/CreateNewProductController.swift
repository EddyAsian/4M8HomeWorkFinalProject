//
//  CreateUserViewController.swift
//  URLRequestGet
//
//  Created by Anara on 16/1/23.
//

import UIKit

class CreateNewProduct: UIViewController {
    
    @IBOutlet weak var nameNewProduct: UITextField!
    @IBOutlet weak var priceNewProduct: UITextField!
    @IBOutlet weak var descriptionNewProduct: UITextField!
    @IBOutlet weak var brandNewProduct: UITextField!
    @IBOutlet weak var idNewProduct: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = UISearchBar()
        var component = URLComponents()
        component.host = "https"
        component.scheme = "dummyjson.com"
        component.path = "products/search"
        component.queryItems = [
            .init(name: "q", value: searchBar.text)
        ]
    }
    
    @IBAction private func createTapped(_sender: UIButton) {
        guard let title = nameNewProduct.text,
              !title.isEmpty,
              let price: Int = Int(priceNewProduct.text!),
              //              !price.isEmpty,
              let description = descriptionNewProduct.text,
              !description.isEmpty,
              let brand = brandNewProduct.text,
              !brand.isEmpty,
              let id: Int = Int(idNewProduct.text!) else {
            showFillAlert()
            return
        }
        let createProduct = ProductArray(id: id,
                                         title: title,
                                         thumbnail: "fsff",
                                         category: "different",
                                         brand: brand,
                                         price: price,
                                         stock: 34,
                                         rating: 13,
                                         discountPercentage: 13,
                                         description: description)
        NetworkManager.shared.createProduct(with: createProduct)
    }
    
    func showFillAlert() {
        let alertVC = UIAlertController(title: "Error", message: "Вы не заполнили все поля", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}






