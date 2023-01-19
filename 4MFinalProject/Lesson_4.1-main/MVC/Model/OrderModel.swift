import UIKit

let orderJson = """
[
    {
            "image": "phone",
            "label": "Phone"
    },

    {
            "image": "laptop",
            "label": "Laptop"
    },

    {
            "image": "parfume",
            "label": "Parfume"
    },

    {
            "image": "cream",
            "label": "Cream"
    },

    {
            "image": "oil",
            "label": "Oil"
    },

    {
            "image": "different",
            "label": "Different"
    },

    {
            "image": "Image4",
            "label": "Pharmacy"
    }
]
"""

struct OrderModel:Decodable {
    let image: String
    let label: String
}

class GetOrderData {
    var orderJSData: [OrderModel] = []
    
    func getData() {
        let data = Data(orderJson.utf8)
        let decoder = JSONDecoder()
        
        do {
            let convertedData = try decoder.decode([OrderModel].self, from: data)
            orderJSData = convertedData
        } catch {
            print("Error is: \(error.localizedDescription)")
        }
    }
}
