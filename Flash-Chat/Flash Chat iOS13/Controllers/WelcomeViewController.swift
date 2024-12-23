import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        registerButton.layer.cornerRadius = 10
        logInButton.layer.cornerRadius = 10

        titleLabel.text = K.appName
        
//        super.viewDidLoad()
//        titleLabel.text = ""
//        
//        let title: String = "⚡️FlashChat"
//        var TimerValue: Double = 0
//
//        for letter in title {
//            Timer.scheduledTimer(withTimeInterval: 0.1 * TimerValue, repeats: false) { (timer) in
//                self.titleLabel.text?.append(letter)
//            }
//            TimerValue += 1
//        }
        
       
    }
    

}
