import UIKit

let serviceJson = """
[
    {
            "image": "bicycle",
            "label": "Delivery"
    },

    {
            "image": "box.truck",
            "label": "Pickup"
    },

    {
            "image": "sailboat",
            "label": "Catering"
    },

    {
            "image": "scooter",
            "label": "Fast"
    },

    {
            "image": "ferry",
            "label": "Boat"
    },

    {
            "image": "fork.knife",
            "label": "Kitchen"
    },

    {
            "image": "rectangle.roundedtop",
            "label": "Leading"
    },

    {
            "image": "car",
            "label": "Driving"
    }
]
"""

struct ServiceDataModel: Decodable {
    let image: String
    let label: String
}

class GetServiceData {
    var serviceJSData: [ServiceDataModel] = []
    
    func getData() {
        let data = Data(serviceJson.utf8)
        let decoder = JSONDecoder()
        
        do {
            let convertedData = try decoder.decode([ServiceDataModel].self, from: data)
            serviceJSData = convertedData
        } catch {
            print("Error is: \(error.localizedDescription)")
        }
    }
}
