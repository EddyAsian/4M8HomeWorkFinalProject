import UIKit

class ProductController {
    
    private var view: MainViewController!
    private var model: ProductModel?
    var productsTableView: UITableView?
    
    init(view: MainViewController!) {
        self.view = view
        model = ProductModel(controller: self)
    }
    
    var phones: [ProductArray]?
    func getPhonesData () {
        model?.getProductsData()
        print("get phones data in controller")
        phones = model?.products
    }
    func returnToViewPhones() -> [ProductArray]? {
        return phones
    }
}



