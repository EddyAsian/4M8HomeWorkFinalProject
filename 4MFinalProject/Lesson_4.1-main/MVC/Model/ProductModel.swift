import Foundation

struct Products: Codable {
    let products: [ProductArray]
}

struct ProductArray: Codable {
    let id: Int
    let title: String
    let thumbnail: String
    let category: String
    let brand: String
    let price: Int
    let stock: Int
    let rating: Double
    let discountPercentage: Double
    let description: String
}

class ProductModel {
    private weak var controller: ProductController?
    
    init(controller: ProductController?) {
        self.controller = controller
    }
    
    var products: [ProductArray]?
    private let networkManager = NetworkManager()
    
    func getProductsData() {
        networkManager.fetchData { result in
            print("completion handler in model nm")
            switch result {
            case .success(let phonesData):
              print(phonesData)
                self.products = phonesData.products
                print("Got \(self.products?.count ?? 0) data")
            case .failure(let error):
                print("Error in completion handler in model: \(error.localizedDescription).")
            }
        }
       print("Model print")
    }
}
