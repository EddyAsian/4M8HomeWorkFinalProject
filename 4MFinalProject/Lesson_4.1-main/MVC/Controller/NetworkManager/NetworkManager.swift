import Foundation

enum HTTPRequest: String {
    case DELETE, POST, GET, PUT
    
    var title: String {
        switch self  {
        case .DELETE:
            return "DELETE"
        case .POST:
            return "POST"
        case .GET:
            return "GET"
        case .PUT:
            return "PUT"
        }
    }
}


class NetworkManager {
    static let shared = NetworkManager()
    var urlPath = URL(string: "https://dummyjson.com/products")!
    
    func deletePhone(by id: Int) {
        var request = URLRequest(url: urlPath.appendingPathComponent("\(id)"))
        request.httpMethod = HTTPRequest.DELETE.rawValue
        let task = URLSession(configuration: .default)
            .dataTask(with: request) { data, response, error in
                // 2 - 100 сек выполняется запрос
                if let error = error {
                    print("Error is \(error.localizedDescription)")
                }
                print(response as Any)
            }
        task.resume()
    }
    
    func createProduct(with model: ProductArray) {
        var request = URLRequest(url: urlPath.appendingPathComponent("add"))
        request.httpMethod = "POST"
        request.httpBody = encodeData(model)
        let task = URLSession(configuration: .default)
            .dataTask(with: request) { data, response, error in
                // 2 - 100 сек выполняется запрос
                if let error = error {
                    print("Error is \(error.localizedDescription)")
                }
                print(String(data: data!, encoding: .utf8) as Any)
            }
        task.resume()
    }
    
    func fetchData (completion: @escaping (Result<Products, Error>) -> Void) {
        let urlPath: String = "https://dummyjson.com/products"
        guard let url = URL(string: urlPath) else {
            print("nil while creating a url!")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            
            guard let data = data else {
                print("Data is nil!!")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Success. Status code: 200")
                } else {
                    print("Got unexpected status code. Status code: \(httpResponse.statusCode)")
                }
            }
            guard error == nil else {
                print("Error occured! Description: \(error!.localizedDescription)")
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let phonesData = try decoder.decode(Products.self, from: data)
                completion(.success(phonesData))
            } catch {
                print("Error occured while trying to fetch data: \(error.localizedDescription).")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchPhones(completion: @escaping (Result<[ProductArray], Error>) -> Void) {
        let request = URLRequest(url: urlPath)
        let task = URLSession(configuration: .default)
            .dataTask(with: request) { data, response, error in
                // 2 - 100 сек выполняется запрос
                if let error = error {
                    print("Error is \(error.localizedDescription)")
                    completion(.failure(error))
                }
                guard let model = self.decodeData(from: data) else {
                    return
                }
                completion(.success(model.products))
            }
        task.resume()
        print("Our request is", request)
    }
    
    private func decodeData(from data: Data?) -> Products? {
        guard let data else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(Products.self, from: data)
    }
    
    private func encodeData(_ user: ProductArray) -> Data? {
        let jsonEncoder = JSONEncoder()
        return try? jsonEncoder.encode(user)
    }
    
    func searchProducts(with text: String, completion: @escaping (Result<[ProductArray], Error>) -> Void) {
        var urlComponent = URLComponents(string: "https://dummyjson.com/products/search")!
        urlComponent.queryItems = [.init(name: "q", value: text)]
        
        let request = URLRequest(url: urlComponent.url!)
        
        let task = URLSession(configuration: .default)
            .dataTask(with: request) { data, response, error in
                // 2 - 100 сек выполняется запрос
                if let error = error {
                    print("Error is \(error.localizedDescription)")
                    completion(.failure(error))
                }
                guard let model = self.decodeData(from: data) else {
                    return
                }
                completion(.success(model.products))
            }
        task.resume()
        print("Our request is", request)
    }
}
