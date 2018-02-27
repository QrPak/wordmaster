/*----------------------------------
 
 - Fives -
 
 Created by cubycode ©2017
 All Rights reserved
 
 -----------------------------------*/


import UIKit
import AudioToolbox
import GameKit


/*  GLOBAL VARIABLES */

// Load Best Score
var bestScore = UserDefaults.standard.integer(forKey: "bestScore")


// IMPORTANT: replace the red string below with your own Leaderboard ID (the one you've set in iTunes Connect)
var leaderboardID = "com.bestscore.fives"



class HomeVC: UIViewController,
GKGameCenterControllerDelegate
{

    /* Variables */
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    // Labels
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet var bestLbl: UILabel!
  
    // Buttons
    @IBOutlet weak var playOutlet: UIButton!
    @IBOutlet weak var shareOutlet: UIButton!
    @IBOutlet weak var gameCenterOutlet: UIButton!
    
    @IBOutlet weak var logoImage: UIImageView!
    
    // Container Views
    @IBOutlet weak var buttonsContainer: UIView!
    @IBOutlet weak var centerContainer: UIView!
    
    
    @IBOutlet weak var imageForShare: UIImageView!
    
    
    
    
override var prefersStatusBarHidden : Bool {
        return true
}
override func viewDidLoad() {
        super.viewDidLoad()

    // Get Best Score
    if bestScore != 0 {
    bestScoreLabel.text = "\(bestScore)"
    } else {
        bestScoreLabel.text = "0"
    }
    
    // Call the GC authentication controller
    authenticateLocalPlayer()
    
    
    // Round buttons corners
    playOutlet.layer.cornerRadius = 8
    shareOutlet.layer.cornerRadius = 6
    gameCenterOutlet.layer.cornerRadius = 6
    logoImage.layer.cornerRadius = 25
    
    
    // Reposition container views on iPad
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
        buttonsContainer.center = CGPoint(x: view.frame.size.width/2, y: centerContainer.frame.origin.y + 300)
    }
    
    bestLbl.text = NSLocalizedString("BEST", comment: "")
    
}

    
@IBAction func playButt(_ sender: AnyObject) {
    let filePath = Bundle.main.path(forResource: "resetWord", ofType: "mp3")
    soundURL = URL(fileURLWithPath: filePath!)
    AudioServicesCreateSystemSoundID(soundURL! as CFURL, &soundID)
    AudioServicesPlaySystemSound(soundID)
    
}


// GAME CENTER BUTTON ============================================
@IBAction func gameCenterButt(_ sender: AnyObject) {
    let gcVC: GKGameCenterViewController = GKGameCenterViewController()
    gcVC.gameCenterDelegate = self
    gcVC.viewState = GKGameCenterViewControllerState.leaderboards
    gcVC.leaderboardIdentifier = leaderboardID
    present(gcVC, animated: true, completion: nil)
}
    
    
    
// SHARE BUTTON ==================================================
@IBAction func shareButt(_ sender: AnyObject) {
    let firstStr = NSLocalizedString("My best score on #Fives is", comment: "")
    let secondStr = NSLocalizedString("can you beat it?", comment: "")
    let messageStr = "\(firstStr) \(bestScore), \(secondStr)"
    let image = imageForShare.image
    let shareItems = [messageStr, image!] as [Any]
    
    let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
    activityViewController.excludedActivityTypes = [.print, .postToWeibo, .copyToPasteboard, .addToReadingList, .postToVimeo]
    
    if UIDevice.current.userInterfaceIdiom == .pad {
        // iPad
        let popOver = UIPopoverController(contentViewController: activityViewController)
        popOver.present(from: .zero, in: view, permittedArrowDirections: .any, animated: true)
    } else {
        // iPhone
        present(activityViewController, animated: true, completion: nil)
    }
}
   
    
    
// MARK: - AUTHENTICATE LOCAL PLAYER FOR GAME CENTER
func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1 Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) -> Void in
                    if error != nil {
                        print(error as Any)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })
            } else {
                // 3 Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error as Any)
            }
            
        }
}

    
func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    gameCenterViewController.dismiss(animated: true, completion: nil)
}

    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}
}
