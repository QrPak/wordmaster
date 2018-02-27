/*----------------------------------
 
 - Fives -
 
 Created by cubycode ©2017
 All Rights reserved
 
 -----------------------------------*/

import UIKit
import GameKit


class GameOverVC: UIViewController,
GKGameCenterControllerDelegate
{
    
    // Labels
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var possibleWordLabel: UILabel!
    @IBOutlet weak var otherWordsLabel: UILabel!
    
    @IBOutlet var youCouldLbl: UILabel!
    @IBOutlet var youScoredLbl: UILabel!
    
    // Buttons
    @IBOutlet weak var shareOutlet: UIButton!
    @IBOutlet weak var homeOutlet: UIButton!
    
    // Image to be shared
    @IBOutlet weak var logoToBeShared: UIImageView!

    
    
override var prefersStatusBarHidden : Bool {
        return true
}
override func viewDidLoad() {
        super.viewDidLoad()
    
    // Set Localizable text
    youCouldLbl.text = NSLocalizedString("You could have made", comment: "")
    youScoredLbl.text = NSLocalizedString("You scored", comment: "")
    
    
    // Get latest score reached
    scoreLabel.text = "\(score)"
    
    // Get the word you could have made
    possibleWordLabel.text = "\(stringsArray[0])"
    
    // Get the other words you could have made
    if stringsArray.count > 1 {
        let firstStr = NSLocalizedString("Or other", comment: "")
        let secondStr = NSLocalizedString("words", comment: "")
        otherWordsLabel.text = "\(firstStr) \(stringsArray.count-1) \(secondStr)"
    } else {
        otherWordsLabel.text = ""
    }
    
    
    // Submit Best Score to leaderboard
    submitBestScore()
    
    // Get background color (based on last words to guess)
    view.backgroundColor = randomColor
    
    // Round buttons corners
    shareOutlet.layer.cornerRadius = 6
    homeOutlet.layer.cornerRadius = 6
}

 
    
    
// SHARE BUTTON
@IBAction func shareButt(_ sender: AnyObject) {
    let firstStr = NSLocalizedString("I've just made", comment: "")
    let secondStr = NSLocalizedString("as score on #Fives", comment: "")
    
    let messageStr = "\(firstStr) \(score) \(secondStr)"
    let image = logoToBeShared.image
    let shareItems = [messageStr, image!] as [Any]
    
    let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
    activityViewController.excludedActivityTypes = [.print, .postToWeibo, .copyToPasteboard, .addToReadingList, .postToVimeo]
    
    if UIDevice.current.userInterfaceIdiom == .pad {
        // iPad
        let popOver = UIPopoverController(contentViewController: activityViewController)
        popOver.present(from: .zero, in: view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
    } else {
        // iPhone
        present(activityViewController, animated: true, completion: nil)
    }
}

    
    
// SUBMIT BEST SCORE TO GAME CENTER'S LEADERBOARD
func submitBestScore() {
    let bestScoreInt = GKScore(leaderboardIdentifier: leaderboardID)
    bestScoreInt.value = Int64(bestScore)
    GKScore.report([bestScoreInt], withCompletionHandler: { (error) -> Void in
        if error != nil { print(error!.localizedDescription)
        } else { print("Best Score submitted to your Leaderboard!") }
    }) 
}
func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    gameCenterViewController.dismiss(animated: true, completion: nil)
}

    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}

}
