
import UIKit

class TutorialStepViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    
    var image: UIImage?
    var text: String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.image = image
        
        if let text = text {
            let font = UIFont(name: "HelveticaNeue-Light", size: 20.0)!
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 8
            paragraphStyle.alignment = .center
            
            textLabel.attributedText = NSAttributedString(string: text,attributes: [NSAttributedString.Key.font : font, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        }
    }
}
