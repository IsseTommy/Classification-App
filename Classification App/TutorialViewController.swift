import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    var pages = [TutorialStepViewController]()
    var imageArray = ["img_01","img_02","img_03"]
    var textArray = ["+のボタンから必要な情報の名前を設定する","名前を上の欄に記入、必要であれば情報を記入してください。記入しないと情報は登録されません。","名前のボタンを押すとその情報の画面に移り、真ん中下の+ボタンで情報を追加できます。編集ボタンを押すと並び替えができます。"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
//        scrollView.backgroundColor = .red
        view.addSubview(scrollView)
//        view.addSubview(pageControl)
        scrollView.isPagingEnabled = true

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        pageControl.frame = CGRect(x: 10, y: view.frame.size.height - 100, width: view.frame.size.width - 20, height: 70)

        scrollView.frame = CGRect(x: 0, y: 60, width: view.frame.size.width, height: view.frame.size.height)
        if scrollView.subviews.count == 2 {
            configureScrollView()
        }
        
    }
    func configureScrollView () {
        scrollView.contentSize = CGSize(width: view.frame.size.width * 3, height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        
        for x in 0..<3 {
            let testImage = UIImageView(image: UIImage(named: imageArray[x]))
            let testLabel = UILabel()
            testLabel.numberOfLines = 0
            testLabel.frame = CGRect(x: 35+(360*x), y: 520, width: 340, height: 100)
            testImage.frame = CGRect(x: 100+(360*x), y: 30, width: 200, height: 500)
            testLabel.text = textArray[x]
            self.view.addSubview(testLabel)
            scrollView.addSubview(testLabel)
            self.view.addSubview(testImage)
            scrollView.addSubview(testImage)
//            let titleLabel = UILabel() // ラベルの生成
//            titleLabel.frame = CGRect(x: 0, y: 500, width: UIScreen.main.bounds.size.width, height: 44) // 位置とサイズの指定
//            titleLabel.textAlignment = NSTextAlignment.center // 横揃えの設定
//            titleLabel.text = "アプリのタイトル" // テキストの設定
//
//            self.view.addSubview(titleLabel)

        }
    }

}
