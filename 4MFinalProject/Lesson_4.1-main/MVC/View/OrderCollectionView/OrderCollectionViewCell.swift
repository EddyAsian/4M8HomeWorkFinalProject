import UIKit

class OrderCollectionViewCell: UICollectionViewCell {
    public static let reusedID = String(describing: OrderCollectionViewCell.self)
    @IBOutlet private weak var orderCustomView: UIView!
    @IBOutlet private weak var categoryImage: UIImageView!
    @IBOutlet private weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func display(item: OrderModel) {
        categoryImage.image = UIImage(named: item.image)
        categoryLabel.text = item.label
    }
}
