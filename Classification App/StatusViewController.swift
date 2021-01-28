
import UIKit
import RealmSwift

class StatusViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var realm: Realm!
    var players: Results<Player>!
    var index: Int!
    var player: Player!
    var index2: Int!
    var titleText: String!
    var numberText: String!
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        players = realm.objects(Player.self).sorted(byKeyPath: "order", ascending: true)
        player = players[index]
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.navigationItem.title = player.name
        
        collectionView.register(UINib(nibName: "MyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyCollectionViewCell")
        collectionView.reloadData()
        navigationItem.rightBarButtonItem = editButtonItem
        players = realm.objects(Player.self).sorted(byKeyPath: "order", ascending: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        realm = try! Realm()
        collectionView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStatusAdd" {
            let nextVC = segue.destination as! StatusAddViewController
            nextVC.index = self.index
        }
        if (segue.identifier == "toEdit") {
            let nextVC = segue.destination as! EditStatusViewController
            nextVC.index = self.index
            nextVC.index2 = self.index2
            titleText = players[index].information[index2].Title
            numberText = players[index].information[index2].value
            nextVC.titleText = self.titleText
            nextVC.numberText = self.numberText
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index2 = indexPath.row
        
        self.performSegue(withIdentifier: "toEdit", sender: nil)
    }
    
    func update() {
        players = realm.objects(Player.self).sorted(byKeyPath: "order", ascending: true)
        player = players[index]
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return player.information.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)  -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        cell.infoNumber.adjustsFontSizeToFitWidth = true
        cell.infoNumber.minimumScaleFactor = 0.3
        cell.infoTitle.adjustsFontSizeToFitWidth = true
        cell.infoTitle.minimumScaleFactor = 0.3
        cell.infoTitleView.layer.cornerRadius = 15
        cell.infoNumberView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        cell.infoNumberView.layer.cornerRadius = 15
        cell.infoTitleView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        cell.infoTitle.text = player.information[indexPath.row].Title
        cell.infoNumber.text = player.information[indexPath.row].value
        if isEditing == true {
            cell.infoTitleView.startVibrateAnimation(range: 3.0)
            cell.infoNumberView.startVibrateAnimation(range: 3.0)
        } else {
            cell.infoNumberView.stopVibrateAnimation()
            cell.infoTitleView.stopVibrateAnimation()
        }
        return cell
    }
    
    @IBAction func addStatus() {
        let newStatus = info()
        let alert = UIAlertController(title: "Add", message: "追加したい属性と要素を入れてください", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "追加する属性の名前"
            textField.clearButtonMode = .whileEditing
            textField.tag = 1
        })
        
        alert.addTextField(configurationHandler: { (textField1) -> Void in
            textField1.keyboardAppearance = .dark
            textField1.keyboardType = .default
            textField1.autocorrectionType = .default
            textField1.placeholder = "属性に設定する値を入力"
            textField1.clearButtonMode = .whileEditing
            textField1.tag = 2
        })
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: {(action) -> Void in
            
            let textFields = alert.textFields!
            for textField in textFields {
                if textField.tag == 1 {
                    newStatus.Title = textField.text ?? "Undefined"
                } else if textField.tag == 2{
                    newStatus.value = textField.text ?? "Undefiend"
                }
            }
            
            try! self.realm.write {
                self.players[self.index].information.append(newStatus)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(submitAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        realm = try! Realm()
    }
}

extension UIView {
    /**
     震えるアニメーションを再生します
     - parameters:
     - range: 震える振れ幅
     - speed: 震える速さ
     - isSync: 複数対象とする場合,同時にアニメーションするかどうか
     */
    func startVibrateAnimation(range: Double = 2.0, speed: Double = 0.15, isSync: Bool = false) {
        if self.layer.animation(forKey: "VibrateAnimationKey") != nil {
            return
        }
        let animation: CABasicAnimation
        animation = CABasicAnimation(keyPath: "transform.rotation");
        animation.isRemovedOnCompletion = false;
        animation.duration = speed;
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 10, y: center.y));
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 10, y: center.y));
        animation.repeatCount = Float.infinity;
        animation.autoreverses = true;
        self.layer.add(animation, forKey: "VibrateAnimationKey")
    }
    /// 震えるアニメーションを停止します
    func stopVibrateAnimation() {
        self.layer.removeAnimation(forKey: "VibrateAnimationKey")
    }
}

