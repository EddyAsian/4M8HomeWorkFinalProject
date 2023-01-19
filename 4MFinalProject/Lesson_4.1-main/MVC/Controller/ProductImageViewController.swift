import UIKit

class ProductImageViewController: UIViewController {
    
    @IBOutlet weak var productImage: UIImageView!
    var imageAtOpeningVC = UIImage()
    
    override func viewDidLoad() {
        productImage.image = imageAtOpeningVC
    }
}
