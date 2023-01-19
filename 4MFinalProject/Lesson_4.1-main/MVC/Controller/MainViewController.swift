import UIKit

class MainViewController: UIViewController {
    @IBOutlet private weak var serviceCollectionView: UICollectionView!
    @IBOutlet private weak var orderCollectionView: UICollectionView!
    @IBOutlet private weak var productTableView: UITableView!
    
    var searchResponse: Products? = nil
    let searchController = UISearchController(searchResultsController: nil)
    private var serivceDataCellIndex: IndexPath? = nil
    private var controller: ProductController?
    private var products: [ProductArray] = []
    private var searchedProducts : [ProductArray] = []
    
    @IBAction func refreshDataButtonTapped(_ sender: Any) {
        controller?.getPhonesData()
        products = (controller?.returnToViewPhones())!
        print(products.count as Any)
        productTableView.reloadData()
    }
    
    let dataJSService = GetServiceData()
    let dataJSOrder = GetOrderData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureServiceCV()
        dataJSService.getData()
        dataJSOrder.getData()
        configureProductTableView()
        setupSearchBar()
        fetchProducts()
        controller = ProductController(view: self)
        controller?.getPhonesData()
        productTableView.reloadData()
        //        let urlString = "https://dummyjson.com/products/search?q=phone"
        //        guard let url = URL(string: urlString) else { return }
        //        URLSession.shared.dataTask(with: url) { data, response, error in
        //            DispatchQueue.main.async {
        //                if let error = error {
        //                    print("Some error")
        //                    return
        //                }
        //                guard let data = data else { return }
        //                let someString = String(data: data, encoding: .utf8)
        //                print(someString ?? "no data")
        //            }
        //        }.resume()
        
        
        
        let searchBar = UISearchBar()
        var component = URLComponents()
        component.host = "https"
        component.scheme = "dummyjson.com"
        component.path = "products/search"
        component.queryItems = [
            .init(name: "q", value: searchBar.text)
        ]
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func configureServiceCV() {
        serviceCollectionView.dataSource = self
        serviceCollectionView.delegate = self
        serviceCollectionView.register(
            UINib(nibName: String(describing: ServiceCollectionViewCell.self), bundle: nil),
            forCellWithReuseIdentifier: ServiceCollectionViewCell.reusedID
        )
        
        orderCollectionView.dataSource = self
        orderCollectionView.delegate = self
        orderCollectionView.register(
            UINib(nibName: String(describing: OrderCollectionViewCell.self), bundle: nil),
            forCellWithReuseIdentifier: OrderCollectionViewCell.reusedID
        )
    }
    
    private func configureProductTableView() {
        productTableView.dataSource = self
        productTableView.delegate = self
        productTableView.register(
            UINib(nibName: String(describing: ProductTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: ProductTableViewCell.reusedID
        )
    }
    
    
    private func fetchProducts() {
        NetworkManager.shared.fetchPhones { [weak self] result in
            guard let `self` = self else { return }
            if case .success(let phones) = result {
                DispatchQueue.main.async {
                    self.products = phones
                    self.productTableView.reloadData()
                }
            }
        }
    }
    
    private func deletePhone(by id: Int) {
        NetworkManager.shared.deletePhone(by: id)
    }
    
    private func handlerDeletePhone(indexPath: IndexPath) {
        let id = products[indexPath.row].id
        deletePhone(by: id)
        products.remove(at: indexPath.row)
        productTableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == serviceCollectionView {
            return dataJSService.serviceJSData.count
        } else {
            return dataJSOrder.orderJSData.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if collectionView == serviceCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ServiceCollectionViewCell.reusedID,
                for: indexPath
            ) as? ServiceCollectionViewCell else {
                fatalError()
            }
            let product = dataJSService.serviceJSData[indexPath.row]
            cell.display(item: product)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OrderCollectionViewCell.reusedID,
                for: indexPath
            ) as? OrderCollectionViewCell else {
                fatalError()
            }
            let category = dataJSOrder.orderJSData[indexPath.row]
            cell.display(item: category)
            return cell
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == serviceCollectionView {
            return CGSize(width: 105, height: 40)
        } else {
            return CGSize(width: 100, height: 90)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
            if collectionView == serviceCollectionView {
                guard let cell = collectionView.cellForItem(
                    at: indexPath
                ) else {
                    return
                }
                if indexPath != serivceDataCellIndex && serivceDataCellIndex != nil {
                    guard let cell = collectionView.cellForItem(
                        at: serivceDataCellIndex!
                    ) else {
                        return
                    }
                    cell.backgroundColor = .white
                }
                cell.backgroundColor = UIColor(
                    red: 0.99, green: 1.00, blue: 0.76, alpha: 1.00
                )
                serivceDataCellIndex = indexPath
            }
        }
}

extension MainViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        print("Table view quantity:\(products.count)")
        return products.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProductTableViewCell.reusedID,
            for: indexPath
        ) as? ProductTableViewCell else {
            fatalError()
        }
        let product = products[indexPath.row]
        cell.display(product: product)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 350
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            handlerDeletePhone(indexPath: indexPath)
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NetworkManager.shared.searchProducts(with: searchText) { [weak self] result in
            guard let `self` = self else { return }
            if case .success(let searchedProducts) = result {
                DispatchQueue.main.async {
                    self.products = searchedProducts
                    self.productTableView.reloadData()
                }
            }
        }
    }
}

//extension MainViewController: ProductCellImageDelegate {
//    func openNewImageViewController(_ item: PhoneModel) {
//        let imageVC = storyboard?.instantiateViewController(
//            withIdentifier: "productimagevc"
//        ) as! ProductImageViewController
//        imageVC.imageAtOpeningVC = UIImage(named: item.productImage)!
//        navigationController?.pushViewController(imageVC, animated: true)
//    }
//}


