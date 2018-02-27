/*----------------------------------
 
 - Fives -
 
 Created by cubycode ©2017
 All Rights reserved
 
 -----------------------------------*/


import UIKit
import QuartzCore
import AudioToolbox
import Foundation
import GoogleMobileAds






/* ------------- GLOBAL VARIABLES ------------- */
var wordStr = ""
var wordIndex = 0
var charArray:[Character] = []
var words: NSArray?
var tapsCount = 0
var wordByCharacters = ""

var stringsArray = [""]
var firstWord = ""
var secondWord = ""
var thirdWord = ""


var soundName = ""
var soundURL: URL?
var soundID:SystemSoundID = 0

var score = 0


// Array of colors for labels and buttons
let colorsArray = [
    UIColor(red: 160.0/255.0, green: 212.0/255.0, blue: 104.0/255.0, alpha: 1.0),
    UIColor(red: 251.0/255.0, green: 110.0/255.0, blue: 82.0/255.0, alpha: 1.0),
    UIColor(red: 79.0/255.0, green: 192.0/255.0, blue: 232.0/255.0, alpha: 1.0),
    UIColor(red: 236.0/255.0, green: 136.0/255.0, blue: 192.0/255.0, alpha: 1.0),
    UIColor(red: 172.0/255.0, green: 146.0/255.0, blue: 237.0/255.0, alpha: 1.0)
]
var randomColor: UIColor?



// IMPORTANT: REPLACE THE RED STRING BELOW WITH THE UNIT ID YOU'VE GOT BY REGISTERING YOUR APP IN http://apps.admob.com
let ADMOB_BANNER_UNIT_ID = "ca-app-pub-9328017061927705/7436855090"







// MARK: - GAMEBOARD CONTROLLER
class GameBoard: UIViewController,
GADBannerViewDelegate
{
    //Ad banners properties
    var adMobBannerView = GADBannerView()
    
    // Letter labels
    @IBOutlet var topLabels: [UILabel]!
    @IBOutlet var shakeLbl: UILabel!
    
    // Letter buttons
    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet weak var buttonsContainerView: UIView!
    
    // Circular Progress View
    var circularProgress: KYCircularProgress!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    
    
    /*  Variables  */
    var progress = 0
    var timer: Timer?
    
    
    
    
    
    
override var prefersStatusBarHidden : Bool {
        return true
}
    
// Respond to shake gesture event
override var canBecomeFirstResponder : Bool {
        return true
}
    
override func viewDidLoad() {
        super.viewDidLoad()

    // Set Localizable text
    shakeLbl.text = NSLocalizedString("Shake to reset", comment: "")
    
    // Reset Score label
    scoreLabel.text = "0"
    score = 0
    
    // Reposition the buttons container View on iPad
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
       buttonsContainerView.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
    }
    
    
    // Setup the circular progress and fire its timer
    setupCircularProgress()
    timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)

    
    // Get the device Language (by its first 2-letter string)
    let language = Locale.preferredLanguages[0]
    let langArr = language.components(separatedBy: "-")
    var deviceLanguageCode = langArr[0]
    print("DEVICE LANGUAGE: \(deviceLanguageCode)")
    
    
    // If the device has a language you have not set into the .plist file, it'll return English as default
    if deviceLanguageCode != "en"
    && deviceLanguageCode != "it"
    && deviceLanguageCode != "de" {
        deviceLanguageCode = "en"
    }
    
    
    // Read the WordsList.plist file ---------------------
    let dictRoot = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "WordsList", ofType: "plist")!)
    words = dictRoot?.object(forKey: deviceLanguageCode) as! NSArray!
    //----------------------------------------------
    
    
    // Setup letter Buttons
    resetLetterButtons()
    
    // Setup top Labels
    resetTopLabels()
    
    
    // Reset taps count
    tapsCount = -1
    
    // Get a random word from WordsList.plist
    getRandomWord()
    
    
    // Initialize ad banners
    initAdMobBanner()
}


    
    
    
// MARK: - GET A RANDOM WORD
func getRandomWord() {
    // Get a random word
    let randomWord = Int(arc4random() % UInt32(words!.count) )
    wordStr = "\(words![randomWord])"
    print("words: \(words!.count)")
    
    // Get an array of words (if there are multiple words
    stringsArray = wordStr.components(separatedBy: ".")
    print("WORDS: \(stringsArray)")
    
    
    // Empty the charArray
    charArray.removeAll(keepingCapacity: true)
    
    // Get the complete word as a set of characters
    for _ in 0..<5 {
        let arr = Array(wordStr)
        charArray = arr
    }
   // print("charArr: \(charArray)")
    
    
    // Get a random color
    let randomColorInt = Int(arc4random() % UInt32(colorsArray.count))
    randomColor = colorsArray[randomColorInt]
    
    
    // Get Random characthers function
    getRandomChar()
}

    
// MARK: - GET RANDOM CHARACTERS
func getRandomChar() {
    // Get a random combination that displays characters on the Game Board
    let randomCombination = Int(arc4random() % 3)
    // println("char combin.: \(randomCombination)")
    
    switch randomCombination {
        case 0:
        letterButtons[1].setTitle("\(charArray[0])", for: .normal)
        letterButtons[0].setTitle("\(charArray[1])", for: .normal)
        letterButtons[4].setTitle("\(charArray[2])", for: .normal)
        letterButtons[2].setTitle("\(charArray[3])", for: .normal)
        letterButtons[3].setTitle("\(charArray[4])", for: .normal)
        
        case 1:
        letterButtons[3].setTitle("\(charArray[0])", for: .normal)
        letterButtons[0].setTitle("\(charArray[1])", for: .normal)
        letterButtons[4].setTitle("\(charArray[2])", for: .normal)
        letterButtons[1].setTitle("\(charArray[3])", for: .normal)
        letterButtons[2].setTitle("\(charArray[4])", for: .normal)
        
        case 2:
        letterButtons[4].setTitle("\(charArray[0])", for: .normal)
        letterButtons[1].setTitle("\(charArray[1])", for: .normal)
        letterButtons[0].setTitle("\(charArray[2])", for: .normal)
        letterButtons[3].setTitle("\(charArray[3])", for: .normal)
        letterButtons[2].setTitle("\(charArray[4])", for: .normal)
    
    default:break }
    
    
    // Call reset Word function
    resetWord()
}
   
   
    
    
    
// MARK: - SETUP CIRCULAR PROGRESS
func setupCircularProgress() {
    circularProgress = KYCircularProgress(frame: CGRect(x: 0, y: 0, width: 280, height: 280))
    circularProgress.colors = [0xf36087, 0xf36087, 0xf36087, 0xf36087]
    circularProgress.center = CGPoint(x: buttonsContainerView.frame.size.width/2, y: buttonsContainerView.frame.size.height/2)
    circularProgress.lineWidth = 6
    
    circularProgress.progressChangedClosure({ (progress: Double, circularView: KYCircularProgress) in
       // println("progress: \(progress)")
    })
    buttonsContainerView.addSubview(circularProgress)
    buttonsContainerView .sendSubview(toBack: circularProgress)
    
}
    
@objc func updateTimer() {
    progress = progress + 1
    let normalizedProgress = Double(progress) / 255.0
    circularProgress.progress = normalizedProgress
    // println("progress: \(normalizedProgress)")
    
    // Timer ends, Game Over!
    if normalizedProgress >= 1.01 {
        timer?.invalidate()
        // println("GAME OVER!!")
        
        // Call GameOver function
        gameOver()
    }
}
 
    
    
// MARK: - GAME OVER
func gameOver() {
    
    // Save Best Score
    if bestScore <= score {
        bestScore = score
        UserDefaults.standard.set(bestScore, forKey: "bestScore")
        UserDefaults.standard.synchronize()
    }
    
    // Play a sound
    soundName = "gameOver"
    playWav()
    
    
    // Go to Game Over VC
    let goVC = self.storyboard?.instantiateViewController(withIdentifier: "GameOverVC") as! GameOverVC
    present(goVC, animated: true, completion: nil)
}

    
    

    
    
// MARK: - LETTER BUTTON TAPPED
@IBAction func letterButtTapped(_ sender: AnyObject) {
    let button = sender as! UIButton
    
    tapsCount += 1
   // print("tapsCount: \(tapsCount)")
    
    // Set topLabels letter
    topLabels[tapsCount].isHidden = false
    topLabels[tapsCount].text = "\(button.titleLabel!.text!)"
    topLabels[tapsCount].backgroundColor = randomColor!
    topLabels[tapsCount].layer.borderWidth = 0
    
    // Create a string by shown characters
    wordByCharacters = wordByCharacters + "\(topLabels[tapsCount].text!)"
    print("word By Char: \(wordByCharacters)")
    
    
    // Change buttons status
    button.backgroundColor = UIColor.clear
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.white.cgColor
    button.isEnabled = false
    button.layer.shadowOpacity = 0.0

    
    // Play a sound
    soundName = "buttTapped"
    playMp3()
    
    
    // You've tapped all buttons, so check your result out
    if tapsCount == 4 {
        checkResult()
    }
}

    
    
    
    

// MARK: - CHECK RESULTS
func checkResult() {
    
    // YOU'VE GUESSED THE WORD!
    firstWord = stringsArray[0]
    if stringsArray.count == 2 {
       secondWord = stringsArray[1]
    }
    if stringsArray.count == 3 {
        secondWord = stringsArray[1]
        thirdWord = stringsArray[2]
    }
    
    if wordByCharacters == firstWord  ||
       wordByCharacters == secondWord ||
       wordByCharacters == thirdWord  {
        
        // Play a sound
        soundName = "rightWord"
        playWav()
        
        progress = progress - 40
        updateTimer()
        
        // Update Score
        score = score + 10
        scoreLabel.text = "\(score)"
        
        // Get a new random word
        getRandomWord()
    //--------------------------------------------------
        
        
        
    // WORD IS WRONG
    } else {
        wordByCharacters = ""
        getRandomChar()
        
        // Play a sound
        soundName = "resetWord"
        playMp3()
    }
}

    
    
    
    
    
    
// MARK: - RESET WORDS BUTTON
func resetWord() {
    // Reset tap Counts
    tapsCount = -1
    
    // reset wordByCharacters
    wordByCharacters = ""
    
    // Reset letter Buttons
    resetLetterButtons()
    
    // Reset top Labels
    resetTopLabels()
}

    
    
    
    
    
// MARK: - RESET TOP LABELS FUNCTION
func resetTopLabels() {
    for labelTAG in 0..<5 {
        topLabels[labelTAG].text = ""
        topLabels[labelTAG].backgroundColor = UIColor.clear
        topLabels[labelTAG].layer.cornerRadius = topLabels[labelTAG].bounds.size.width/2
        topLabels[labelTAG].layer.borderColor = UIColor.white.cgColor
        topLabels[labelTAG].layer.borderWidth = 1
    }
}

    
    
// MARK: - RESET LETTER BUTTONS FUNCTION
func resetLetterButtons() {
    for buttTAG in 0..<5 {
        letterButtons[buttTAG].layer.cornerRadius = letterButtons[buttTAG].bounds.size.width/2
        letterButtons[buttTAG].isEnabled = true
        letterButtons[buttTAG].backgroundColor = randomColor
        letterButtons[buttTAG].layer.borderWidth = 0
        letterButtons[buttTAG].layer.borderColor = UIColor.clear.cgColor
        letterButtons[buttTAG].layer.shadowColor = randomColor?.cgColor
        letterButtons[buttTAG].layer.shadowOffset = CGSize(width: 0, height: 4)
        letterButtons[buttTAG].layer.shadowRadius = 0
        letterButtons[buttTAG].layer.shadowOpacity = 0.5
    }
}

    
    
    
// MARK: - RESET ROUND BY SHAKE GESTURE
override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
       resetWord()
        
        // Play a sound
        soundName = "resetWord"
        playMp3()
    }
}


    
// MARK: - BACK BUTTON (invalidates timer too)
@IBAction func backButt(_ sender: AnyObject) {
        timer?.invalidate()
}
    
    
    
// MARK: - PLAY SOUNDS
func playMp3() {
    let filePath = Bundle.main.path(forResource: soundName, ofType: "mp3")
    soundURL = URL(fileURLWithPath: filePath!)
    AudioServicesCreateSystemSoundID(soundURL! as CFURL, &soundID)
    AudioServicesPlaySystemSound(soundID)
}
func playWav() {
    let filePath = Bundle.main.path(forResource: soundName, ofType: "wav")
    soundURL = URL(fileURLWithPath: filePath!)
    AudioServicesCreateSystemSoundID(soundURL! as CFURL, &soundID)
    AudioServicesPlaySystemSound(soundID)
}
    
    
    
    
    
    
    
    
    
    
// MARK: - ADMOB BANNER METHODS
func initAdMobBanner() {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            // iPad banner
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 728, height: 90))
            adMobBannerView.frame = CGRect(x: 0, y: self.view.frame.size.height, width: 728, height: 90)
            
        } else {
            // iPhone banner
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
            adMobBannerView.frame = CGRect(x: 0, y: self.view.frame.size.height, width: 320, height: 50)
        }
    
        adMobBannerView.adUnitID = ADMOB_BANNER_UNIT_ID
        adMobBannerView.rootViewController = self
        adMobBannerView.delegate = self
        // adMobBannerView.hidden = true
        view.addSubview(adMobBannerView)
        
        let request = GADRequest()
        adMobBannerView.load(request)
}
    
    
    // Hide the banner
    func hideBanner(_ banner: UIView) {
        if banner.isHidden == false {
            UIView.beginAnimations("hideBanner", context: nil)
            banner.frame = CGRect(x: 0, y: view.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
            UIView.commitAnimations()
            banner.isHidden = true
        }
    }
    
    // Show the banner
    func showBanner(_ banner: UIView) {
        var h: CGFloat = 0
        // iPhone X
        if UIScreen.main.bounds.size.height == 812 { h = 20
        } else { h = 0 }
        
        UIView.beginAnimations("showBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2,
                              y: view.frame.size.height - banner.frame.size.height - h,
                              width: banner.frame.size.width, height: banner.frame.size.height);
        UIView.commitAnimations()
        banner.isHidden = false
    }

    
       // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView) {
        print("AdMob loaded!")
        showBanner(adMobBannerView)
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("AdMob Can't load ads right now, they'll be available later \n\(error)")
        hideBanner(adMobBannerView)
    }
    

    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}

}

