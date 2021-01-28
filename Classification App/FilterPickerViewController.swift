
import UIKit
import Realm
import RealmSwift

class FilterPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var realm: Realm!
    var players: Results<Player>!
    @IBOutlet var pickerView: UIPickerView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        players = realm.objects(Player.self)
        pickerView.delegate = self
        pickerView.dataSource = self

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return players.count
    }
    

}
