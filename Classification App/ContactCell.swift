
import UIKit

class ContactCell: UITableViewCell {
    
    var link: MemoTableViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        let starButton = UIButton(type: .system)
        starButton.setImage(UIImage(named: "star_light"), for: .normal)
        starButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        starButton.tintColor = UIColor(red: 186/255, green: 234/255, blue: 199/255, alpha: 1.0)
        starButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
        accessoryView = starButton
    }
    
    
    @objc private func handleMarkAsFavorite() {
        link?.someMethodIWantToCall(cell: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
