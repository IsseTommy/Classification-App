
import UIKit
import RealmSwift

class MyCollectionViewCell: UICollectionViewCell {
    
    var realm: Realm!
    var players: Results<Player>!
    var player: Player!
    
    static let identifier = "MyCollectionViewCell"
    
    @IBOutlet var infoTitle: UILabel!
    @IBOutlet var infoNumber: UILabel!
    @IBOutlet var infoTitleView: UIView!
    @IBOutlet var infoNumberView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        realm = try! Realm()
        players = realm.objects(Player.self)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
}
