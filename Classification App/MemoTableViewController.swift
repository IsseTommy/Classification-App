import UIKit
import RealmSwift
import SideMenu

class MemoTableViewController: UITableViewController{
    @IBOutlet var table: UITableView!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var sortButton: UIButton!
    
    var realm: Realm!
    var players: [Player] = []
    var index: Int!
    
    var nextDestination: String? {
        didSet(val) {
            guard let destination = nextDestination else {
                return
            }
            self.performSegue(withIdentifier: destination, sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        
        table.allowsMultipleSelectionDuringEditing = true
        realm = try! Realm()
        players = Array(realm.objects(Player.self))
        table.reloadData()
        
        tableView.register(ContactCell.self, forCellReuseIdentifier: "Cell")
        self.navigationController?.toolbar.barTintColor = .black
        print(players)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        players = Array(realm.objects(Player.self).sorted(byKeyPath: "order", ascending: true))
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContactCell
        cell.link = self
        cell.textLabel?.text = players[indexPath.row].name
        let player = players[indexPath.row]
        if favoriteButton.currentTitle == "お気に入り解除" {
            if player.hasFavorite == false {
                cell.isHidden = true
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let displayHeight = self.view.frame.height
        let player = players[indexPath.row]
        if favoriteButton.currentTitle == "お気に入り解除" {
            if player.hasFavorite == true {
                return displayHeight / 12
            } else {
                return 0.01
            }
        } else {
            return displayHeight / 12
        }
    }
    
    @IBAction func Sort() {
        //        let displayHeight = self.view.frame.height
        
        if sortButton.currentTitle == "身長で整理" {
            sortButton.setTitle("整理解除", for: .normal)
            players = Array(realm.objects(Player.self).filter("any information.Title = '身長'"))
            players = players.sorted(by: { (player1, player2) -> Bool in
                let info1 = player1.information
                let info2 = player2.information
                let height1 = info1.first { (info) -> Bool in
                    return info.Title == "身長"
                }
                let height2 = info2.first { (info) -> Bool in
                    return info.Title == "身長"
                }
                return (Int(height1?.value ?? "0") ?? 0) < (Int(height2?.value ?? "0") ?? 0)
            })
            tableView.reloadData()
        } else if sortButton.currentTitle == "整理解除" {
            sortButton.setTitle("身長で整理", for: .normal)
            players = Array(realm.objects(Player.self).sorted(byKeyPath: "order", ascending: true))
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        
        self.performSegue(withIdentifier: "toStatus", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                realm.delete(players[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            players = Array(realm.objects(Player.self).sorted(byKeyPath: "order", ascending: true))
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        try! realm.write {
            let sourceObject = players[sourceIndexPath.row]
            let destinationObject = players[destinationIndexPath.row]
            
            let destinationObjectOrder = destinationObject.order
            
            if sourceIndexPath.row < destinationIndexPath.row {
                // 上から下に移動した場合、間の項目を上にシフト
                for index in sourceIndexPath.row...destinationIndexPath.row {
                    let object = players[index]
                    object.order -= 1
                }
            } else {
                // 下から上に移動した場合、間の項目を下にシフト
                for index in (destinationIndexPath.row..<sourceIndexPath.row).reversed() {
                    let object = players[index]
                    object.order += 1
                }
            }
            // 移動したセルの並びを移動先に更新
            sourceObject.order = destinationObjectOrder
        }
        players = Array(realm.objects(Player.self).sorted(byKeyPath: "order", ascending: true))
    }
    
    //値渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStatus" {
            let nextVC = segue.destination as! StatusViewController
            nextVC.index = self.index
        }
        if segue.identifier == "toMenu" {
            let nextVC = segue.destination as! MenuViewController
            nextVC.table = self.table
        }
        if segue.identifier == "toMenu" {
            let nextVC = segue.destination as! MenuViewController
            nextVC.players = realm.objects(Player.self).sorted(byKeyPath: "order", ascending: true)
        }
    }
    
    func someMethodIWantToCall(cell: UITableViewCell) {
        let indexPathTapped = tableView.indexPath(for: cell)
        let player = players[indexPathTapped!.row]
        if players[indexPathTapped!.row].hasFavorite == true {
            try! realm.write {
                player.hasFavorite =  false
                cell.accessoryView?.tintColor = .gray
            }
        } else {
            try! realm.write {
                player.hasFavorite = true
                cell.accessoryView?.tintColor = UIColor(red: 186/255, green: 234/255, blue: 199/255, alpha: 1.0)
            }
        }
        realm = try! Realm()
        tableView.reloadData()
        table.reloadData()
        
    }
    
    @IBAction func ShowFavorite(cell: UITableViewCell) {
        if favoriteButton.currentTitle == "お気に入り表示" {
            favoriteButton.setTitle("お気に入り解除", for: .normal)
        } else if favoriteButton.currentTitle == "お気に入り解除" {
            favoriteButton.setTitle("お気に入り表示", for: .normal)
            players = Array(realm.objects(Player.self).sorted(byKeyPath: "order", ascending: true))
        }
        table.reloadData()
    }
}
