
import UIKit
import RealmSwift

let realm = try! Realm()

class Player: Object {
    @objc dynamic var name = ""
    @objc dynamic var order = 0
    @objc dynamic var hasFavorite = true
    
    let information = List<info>()
}

class info: Object {
    @objc dynamic var Title: String = ""
    @objc dynamic var value: String = ""
}
