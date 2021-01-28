
import UIKit
import RealmSwift

class AddStatusViewController: UIViewController {
    
    var realm: Realm!
    var players: Results<Player>!
    
    @IBOutlet var textField1 : UITextField!
    @IBOutlet var textField2 : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        realm = try! Realm()
        players = realm.objects(Player.self)

    }
    
    
    
}
