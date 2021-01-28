
import UIKit
import RealmSwift

class AddViewController: UIViewController {
    
    var realm: Realm!
    var players: Results<Player>!
    var player: Player!
    var information = info()
    var index = 0
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var infoTextField: UITextField!
    @IBOutlet var infoNumberTextField: UITextField!
    @IBOutlet var infoStringTextField: UITextField!
    @IBOutlet var StringButton: UISwitch!
    @IBOutlet var IntButton: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        infoTextField.placeholder = "情報名を記入"
        realm = try! Realm()
        StringButton.isOn = true
        IntButton.isOn = false
        players = realm.objects(Player.self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveMemo() {
        let newplayer = Player()
        let newStatus = info()
        let alert: UIAlertController = UIAlertController(title: "保存完了", message: "名前の保存に成功しました!", preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { action in
                    newplayer.name = self.textField.text ?? ""
                    newplayer.order = self.players.count
                    newStatus.Title = self.infoTextField.text!
                    if self.StringButton.isOn == true {
                        newStatus.value = self.infoStringTextField.text ?? ""
                    } else {
                        newStatus.value = self.infoNumberTextField.text ?? ""
                    }
                    try! self.realm.write {
                        self.realm.add(newplayer)
                        if self.infoTextField.text != ""{
                            self.players[self.players.count - 1].information.append(newStatus)
                        }
                    }
                    self.navigationController?.popViewController(animated: true)
            }
        ))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { action in print("OK")}))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func back() {
        let alert: UIAlertController = UIAlertController(title: "本当に戻りますか?", message: "記入した名前は保存されません", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: {action in
            print("OK")
        }))
        present(alert, animated: true, completion: nil)
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
    
    @IBAction func inputText(_ sender: Any) {
        
    }
}
