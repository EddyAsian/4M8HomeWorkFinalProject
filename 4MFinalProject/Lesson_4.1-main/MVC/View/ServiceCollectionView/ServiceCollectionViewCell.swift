import UIKit

class ServiceCollectionViewCell: UICollectionViewCell {
    public static let reusedID = String(describing: ServiceCollectionViewCell.self)
    @IBOutlet private weak var serviceCustomView: UIView!
    @IBOutlet private weak var serviceLabel: UILabel!
    @IBOutlet private weak var serviceImageView: UIImageView!
    
    func display(item: ServiceDataModel) {
        serviceLabel.text = item.label
        serviceImageView.image = UIImage(systemName: item.image)
    }
}
