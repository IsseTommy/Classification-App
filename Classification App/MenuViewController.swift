
import UIKit
import RealmSwift
import Realm

class MenuViewController: UIViewController{
    
    @IBOutlet weak var menuView: UIView!
    var table : UITableView!
    var realm: Realm!
    var players: Results<Player>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard: UIStoryboard = self.storyboard!
        let next: UIViewController = storyboard.instantiateViewController(withIdentifier:"Add")
        // 遷移処理
        navigationController?.pushViewController(next, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // メニューの位置を取得する
        let menuPos: CGPoint = self.menuView.layer.position
        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
        self.menuView.layer.position.x = 3 * self.menuView.frame.width
        // 表示時のアニメーションを作成する
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.menuView.layer.position.x = menuPos.x
            },
            completion: nil
        )
    }
    
    // メニューエリア以外タップ時の処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {
                        self.menuView.layer.position.x = 3 * self.menuView.frame.width
                    },
                    completion: { bool in
                        self.dismiss(animated: true, completion: nil)
                    }
                )
            }
        }
    }
    
    @IBAction func toAdd() {
        let nav = self.presentingViewController as! UINavigationController
        let preVC = nav.viewControllers[nav.viewControllers.count-1] as! MemoTableViewController
        self.dismiss(animated: true) {
            preVC.nextDestination = "toAdd"
        }
    }
    @IBAction func sort() {
        table.isEditing = true
        self.dismiss(animated: true, completion: nil)
    }
}
