
import UIKit
import RealmSwift

class EditStatusViewController: UIViewController {
    
    var realm: Realm!
    var players: Results<Player>!
    var information = info()
    var index: Int!
    var index2: Int!
    var titleText: String!
    var numberText: String!
    @IBOutlet var changeTitletext: UILabel!
    @IBOutlet var changeTitleLabel: UILabel!
    @IBOutlet var changeNumberLabel: UILabel!
    @IBOutlet var changeTitle: UITextField!
    @IBOutlet var changeNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        players = realm.objects(Player.self).sorted(byKeyPath: "order", ascending: true)
        changeTitletext.text = "\(titleText!)"
        changeNumber.text = players[index].information[index2].value
        changeTitle.text = titleText!
        changeNumber.placeholder = numberText!
        print(players[index].information[index2].Title)
    }
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func save() {
        if changeTitle.text != nil || changeTitle.text != nil{
            try!  self.realm.write {
                self.players[self.index].information[index2].Title = self.changeTitle.text!
                self.players[self.index].information[index2].value = self.changeNumber.text!
            }
        }
        let nav = self.presentingViewController as! UINavigationController
        let preVC = nav.viewControllers[nav.viewControllers.count-1] as! StatusViewController
        preVC.update()
        self.dismiss(animated: true, completion: nil)
    }
}
