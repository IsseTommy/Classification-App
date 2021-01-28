
import UIKit
import RealmSwift


class StatusAddViewController: UIViewController {
    
    var realm: Realm!
    var players: Results<Player>!
    var player: Player!
    var index: Int!
    @IBOutlet var infoTitleTextField: UITextField!
    @IBOutlet var statustextTextField: UITextField!
    @IBOutlet var statusnumberTextField: UITextField!
    @IBOutlet var StringButton: UISwitch!
    @IBOutlet var IntButton: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        
        self.navigationItem.title = "情報の追加"
        StringButton.isOn = true
        IntButton.isOn = false
        players = realm.objects(Player.self).sorted(byKeyPath: "order", ascending: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func tapped1(_ sender: UISwitch) {
        if StringButton.isOn == true {
            IntButton.isOn = false
        } else {
            IntButton.isOn = true
        }
    }
    
    @IBAction func tapped2(_ sender: UISwitch) {
        if IntButton.isOn == true {
            StringButton.isOn = false
        } else {
            StringButton.isOn = true
        }
    }
    
    @IBAction func addStatus() {
        let newStatus = info()
        newStatus.Title = infoTitleTextField.text ?? "Undefined"
        if StringButton.isOn == true {
        newStatus.value = statustextTextField.text ?? "Undefined"
        } else {
        newStatus.value = statusnumberTextField.text ?? "Undefined"
        }
        
        try! self.realm.write {
            self.players[self.index].information.append(newStatus)
        }

        let nav = self.presentingViewController as! UINavigationController
        let preVC = nav.viewControllers[nav.viewControllers.count-1] as! StatusViewController
        preVC.update()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func calcel() {
        self.dismiss(animated: true, completion: nil)
    }
}
