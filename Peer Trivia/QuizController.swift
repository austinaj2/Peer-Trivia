//
//  QuizController.swift
//  Peer Trivia
//
//  Created by Yabby Yimer Wolle on 5/4/22.
//

import UIKit
import MultipeerConnectivity

class QuizController: UIViewController, MCSessionDelegate, URLSessionDownloadDelegate {

    var player1 = Player()
    var player2 = Player()
    var player3 = Player()
    var player4 = Player()
    var localPeerID: MCPeerID!
    var session: MCSession!
    var finAnswer = String()
    var timer = Timer()
    var timeCount = Int()
    var qNum = 0
    @IBOutlet weak var bubble1: UILabel!
    @IBOutlet weak var bubble2: UILabel!
    @IBOutlet weak var bubble3: UILabel!
    @IBOutlet weak var bubble4: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var question: UITextView!
    @IBOutlet weak var qNumLabel: UILabel!
    @IBOutlet weak var bubble1img: UIImageView!
    @IBOutlet weak var bubble2img: UIImageView!
    @IBOutlet weak var bubble3img: UIImageView!
    @IBOutlet weak var bubble4img: UIImageView!
    @IBOutlet weak var player1img: UIImageView!
    @IBOutlet weak var player2img: UIImageView!
    @IBOutlet weak var player3img: UIImageView!
    @IBOutlet weak var player4img: UIImageView!
    @IBOutlet weak var player1Lbl: UILabel!
    @IBOutlet weak var player2Lbl: UILabel!
    @IBOutlet weak var player3Lbl: UILabel!
    @IBOutlet weak var player4Lbl: UILabel!
    @IBOutlet weak var answerA: UIButton!
    @IBOutlet weak var answerB: UIButton!
    @IBOutlet weak var answerC: UIButton!
    @IBOutlet weak var answerD: UIButton!
    @IBOutlet weak var final: UIButton!
    var qs = [[String: Any]]()
    @IBOutlet weak var score1: UILabel!
    @IBOutlet weak var score2: UILabel!
    @IBOutlet weak var score3: UILabel!
    @IBOutlet weak var score4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        session.delegate = self
        let questionSess = URLSession.shared
        let url = URL(string: "http://www.people.vcu.edu/~ebulut/jsonFiles/quiz1.json")
        let task = questionSess.dataTask(with: url!)  { (data, response, error) in
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed)
                    if let dictionary = json as? [String:Any] {
                        self.readJSONData(dictionary)
                        let q = dictionary["questions"] as? [[String: Any]]
                        DispatchQueue.main.async {
                            self.question.text = q![0]["questionSentence"] as? String
                            let arr = q![0]["options"]
                            if let dictionary = arr as? [String:Any] {
                                self.answerA.setTitle(dictionary["A"] as? String, for: .normal)
                                self.answerB.setTitle(dictionary["B"] as? String, for: .normal)
                                self.answerC.setTitle(dictionary["C"] as? String, for: .normal)
                                self.answerD.setTitle(dictionary["D"] as? String, for: .normal)
                            }
                        }
                    }
                }
                catch{
                    print("Error")
                }
        }
        task.resume()
        print(qs)
        timeCount = 23
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        bubble1.isHidden = true
        bubble2.isHidden = true
        bubble3.isHidden = true
        bubble4.isHidden = true
        player1img.image = player1.img
        player1Lbl.text = "You"
        player2img.image = player2.img
        player2Lbl.text = player2.name
        player3img.image = player3.img
        player3Lbl.text = player3.name
        player4img.image = player4.img
        player4Lbl.text = player4.name
        if player2.name == "Not connected..." {
            player2img.isHidden = true
            player2Lbl.isHidden = true
            score2.isHidden = true
            
        }
        if player3.name == "Not connected..." {
            player3img.isHidden = true
            player3Lbl.isHidden = true
            score3.isHidden = true
        }
        if player4.name == "Not connected..." {
            player4img.isHidden = true
            player4Lbl.isHidden = true
            score4.isHidden = true
        }
    }
    
    func readJSONData(_ object: [String: Any]) {
        if let numQuestions = object["numberOfQuestions"] as? Int,
            let questions = object["questions"] as? [[String: Any]],
            let topic = object["topic"] as? String {
            qs = questions
            let send = questions.description.data(using: .utf8)
            do {
                try session.send(send!, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }

    @IBAction func clickA(_ sender: UIButton) {
        finAnswer = "A"
        if sender.backgroundColor == .opaqueSeparator {
            sender.backgroundColor = .systemOrange
            answerB.backgroundColor = .opaqueSeparator
            answerC.backgroundColor = .opaqueSeparator
            answerD.backgroundColor = .opaqueSeparator
            final.isEnabled = true
        }
        else {
            sender.backgroundColor = .opaqueSeparator
        }
    }
    
    @IBAction func clickB(_ sender: UIButton) {
        finAnswer = "B"
        if sender.backgroundColor == .opaqueSeparator {
            sender.backgroundColor = .systemOrange
            answerA.backgroundColor = .opaqueSeparator
            answerC.backgroundColor = .opaqueSeparator
            answerD.backgroundColor = .opaqueSeparator
            final.isEnabled = true
        }
        else {
            sender.backgroundColor = .opaqueSeparator
        }
    }
    @IBAction func clickC(_ sender: UIButton) {
        finAnswer = "C"
        if sender.backgroundColor == .opaqueSeparator {
            sender.backgroundColor = .systemOrange
            answerB.backgroundColor = .opaqueSeparator
            answerA.backgroundColor = .opaqueSeparator
            answerD.backgroundColor = .opaqueSeparator
            final.isEnabled = true
        }
        else {
            sender.backgroundColor = .opaqueSeparator
        }
    }
    
    @IBAction func clickD(_ sender: UIButton) {
        if sender.backgroundColor == .opaqueSeparator {
            finAnswer = "D"
            sender.backgroundColor = .systemOrange
            answerB.backgroundColor = .opaqueSeparator
            answerC.backgroundColor = .opaqueSeparator
            answerA.backgroundColor = .opaqueSeparator
            final.isEnabled = true
        }
        else {
            sender.backgroundColor = .opaqueSeparator
        }
    }
    
    
    @IBAction func finalize(_ sender: UIButton) {
        let data = finAnswer.data(using: .utf8)
        if finAnswer == "A" {
            answerA.backgroundColor = .systemGreen
        }
        if finAnswer == "B" {
            answerB.backgroundColor = .systemGreen
        }
        if finAnswer == "C" {
            answerC.backgroundColor = .systemGreen
        }
        if finAnswer == "D" {
            answerD.backgroundColor = .systemGreen
        }
        print(finAnswer)
        bubble1img.isHidden = false
        bubble1.isHidden = false
        bubble1.text = finAnswer
        do {
            try session.send(data!, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .notConnected:
                print("Connecting: \(peerID.displayName)")
            case .connecting:
                print("Connecting: \(peerID.displayName)")
            case .connected:
                print("Connected: \(peerID.displayName)")
                print(session.connectedPeers.count)
                var cons = [String]()
                if session.connectedPeers.count>0 {
                    for i in 0...2 {
                        if i < session.connectedPeers.count {
                            cons.append(session.connectedPeers[i].displayName)
                        }
                        else {
                            cons.append("Not connected...")
                        }
                    }
                    print(cons)
                }
            @unknown default:
                fatalError()
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            guard let message = String(data: data, encoding: .utf8) else { return }
            print(peerID.displayName)
            if message == "00" {
                self.question.text = self.qs[0]["questionSentence"] as? String
                let arr = self.qs[0]["options"]
                if let dictionary = arr as? [String:Any] {
                    self.answerA.setTitle(dictionary["A"] as? String, for: .normal)
                    self.answerB.setTitle(dictionary["B"] as? String, for: .normal)
                    self.answerC.setTitle(dictionary["C"] as? String, for: .normal)
                    self.answerD.setTitle(dictionary["D"] as? String, for: .normal)
                }
            }
            if Int(message) == 11 {
                self.question.text = self.qs[1]["questionSentence"] as? String
                let arr = self.qs[1]["options"]
                if let dictionary = arr as? [String:Any] {
                    self.answerA.setTitle(dictionary["A"] as? String, for: .normal)
                    self.answerB.setTitle(dictionary["B"] as? String, for: .normal)
                    self.answerC.setTitle(dictionary["C"] as? String, for: .normal)
                    self.answerD.setTitle(dictionary["D"] as? String, for: .normal)
                }
            }
            if Int(message) == 22 {
                self.question.text = self.qs[2]["questionSentence"] as? String
                let arr = self.qs[2]["options"]
                if let dictionary = arr as? [String:Any] {
                    self.answerA.setTitle(dictionary["A"] as? String, for: .normal)
                    self.answerB.setTitle(dictionary["B"] as? String, for: .normal)
                    self.answerC.setTitle(dictionary["C"] as? String, for: .normal)
                    self.answerD.setTitle(dictionary["D"] as? String, for: .normal)
                }
            }
            if Int(message) == 33 {
                self.question.text = self.qs[3]["questionSentence"] as? String
                let arr = self.qs[3]["options"]
                if let dictionary = arr as? [String:Any] {
                    self.answerA.setTitle(dictionary["A"] as? String, for: .normal)
                    self.answerB.setTitle(dictionary["B"] as? String, for: .normal)
                    self.answerC.setTitle(dictionary["C"] as? String, for: .normal)
                    self.answerD.setTitle(dictionary["D"] as? String, for: .normal)
                }
            }
            if self.player1.name == peerID.displayName {
                if message.count == 1 {
                    self.bubble1img.isHidden = false
                    self.bubble1.isHidden = false
                    self.bubble1.text = message
                }
            }
            if self.player2.name == peerID.displayName {
                if message.count == 1 {
                    self.bubble2.isHidden = false
                    self.bubble2img.isHidden = false
                    self.bubble2.text = message
                }
            }
            if self.player3.name == peerID.displayName {
                if message.count == 1 {
                    self.bubble3.isHidden = false
                    self.bubble3img.isHidden = false
                    self.bubble3.text = message
                }
            }
            if self.player4.name == peerID.displayName {
                if message.count == 1 {
                    self.bubble4.isHidden = false
                    self.bubble4img.isHidden = false
                    self.bubble4.text = message
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func timeFormatter(secs: Int) -> (Int, Int) {
        return ((secs%3600)/60, (secs%3600)%60)
    }
    
    func timeStringFormatter(formatted: (Int, Int)) -> String {
        let t = "\(formatted.0):\(String(format: "%02d", formatted.1))"
        return t
    }
    
    @objc func countdown() {
        let form = timeFormatter(secs: timeCount-3)
        let timeString = timeStringFormatter(formatted: form)
        if timeCount > 3 {
            timeLabel.text = timeString
            timeCount -= 1
            bubble1img.backgroundColor = .clear
            bubble2img.backgroundColor = .clear
            bubble3img.backgroundColor = .clear
            bubble4img.backgroundColor = .clear
        }
        else if timeCount > 0 && timeCount <= 3 {
            timeLabel.text = "0:00"
            let correct = self.qs[qNum]["correctOption"]
            print(correct as! String)
            print(finAnswer)
            if timeCount == 2 {
                if finAnswer == correct as? String {
                    player1.score += 1
                    score1.text = "\(player1.score)"
                    bubble1img.backgroundColor = .systemGreen
                }
                if bubble2.text == correct as? String {
                    player2.score += 1
                    score2.text = "\(player2.score)"
                    bubble2img.backgroundColor = .systemGreen
                }
                if bubble3.text == correct as? String {
                    player3.score += 1
                    score3.text = "\(player3.score)"
                    bubble3img.backgroundColor = .systemGreen
                }
                if bubble4.text == correct as? String {
                    player4.score += 1
                    score4.text = "\(player4.score)"
                    bubble4img.backgroundColor = .systemGreen
                }
            }
            timeCount -= 1
        }
        else if timeCount == 0 {
            if qNum<qs.count-1 {
                print(player1.name)
                print(player1.score)
                bubble1.isHidden = true
                bubble2.isHidden = true
                bubble3.isHidden = true
                bubble4.isHidden = true
                bubble1img.isHidden = true
                bubble2img.isHidden = true
                bubble3img.isHidden = true
                bubble4img.isHidden = true
                timeCount = 23
                timeLabel.text = timeString
                answerA.backgroundColor = .opaqueSeparator
                answerB.backgroundColor = .opaqueSeparator
                answerC.backgroundColor = .opaqueSeparator
                answerD.backgroundColor = .opaqueSeparator
                qNum += 1
                qNumLabel.text = "Question \(qNum+1)/4"
                if session.connectedPeers.count > 0 {
                    do {
                        try session.send("\(qNum)\(qNum)".data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                else {
                    if qNum == 0 {
                        question.text = qs[0]["questionSentence"] as? String
                        let arr = self.qs[0]["options"]
                        if let dictionary = arr as? [String:Any] {
                            answerA.setTitle(dictionary["A"] as? String, for: .normal)
                            answerB.setTitle(dictionary["B"] as? String, for: .normal)
                            answerC.setTitle(dictionary["C"] as? String, for: .normal)
                            answerD.setTitle(dictionary["D"] as? String, for: .normal)
                        }
                    }
                    else if qNum == 1 {
                        question.text = qs[1]["questionSentence"] as? String
                        let arr = self.qs[1]["options"]
                        if let dictionary = arr as? [String:Any] {
                            answerA.setTitle(dictionary["A"] as? String, for: .normal)
                            answerB.setTitle(dictionary["B"] as? String, for: .normal)
                            answerC.setTitle(dictionary["C"] as? String, for: .normal)
                            answerD.setTitle(dictionary["D"] as? String, for: .normal)
                        }
                    }
                    else if qNum == 2 {
                        question.text = qs[2]["questionSentence"] as? String
                        let arr = self.qs[2]["options"]
                        if let dictionary = arr as? [String:Any] {
                            answerA.setTitle(dictionary["A"] as? String, for: .normal)
                            answerB.setTitle(dictionary["B"] as? String, for: .normal)
                            answerC.setTitle(dictionary["C"] as? String, for: .normal)
                            answerD.setTitle(dictionary["D"] as? String, for: .normal)
                        }
                    }
                    else if qNum == 3 {
                        question.text = qs[3]["questionSentence"] as? String
                        let arr = self.qs[3]["options"]
                        if let dictionary = arr as? [String:Any] {
                            answerA.setTitle(dictionary["A"] as? String, for: .normal)
                            answerB.setTitle(dictionary["B"] as? String, for: .normal)
                            answerC.setTitle(dictionary["C"] as? String, for: .normal)
                            answerD.setTitle(dictionary["D"] as? String, for: .normal)
                        }
                    }
                }
            }
            else {
                timeLabel.text = "0:00"
                timer.invalidate()
                qNumLabel.text = "GAME OVER!"
                var max = 0
                var winner = ""
                if max < Int(score1.text!)! {
                    max = Int(score1.text!)!
                    winner = "You won"
                }
                if max < Int(score2.text!)! {
                    max = Int(score2.text!)!
                    winner = "\(String(describing: player2Lbl.text)) wins"
                }
                if max < Int(score3.text!)! {
                    max = Int(score3.text!)!
                    winner = "\(String(describing: player3Lbl.text)) wins"
                }
                if max < Int(score4.text!)! {
                    max = Int(score4.text!)!
                    winner = "\(String(describing: player4Lbl.text)) wins"
                }
                if session.connectedPeers.count > 0 {
                    question.text = "\(winner)!\nThanks for playing!\nTo play again return to the home screen..."
                }
                else {
                    question.text = "Your score was: \(String(describing: score1.text))!\nThanks for playing!\nTo play again return to the home screen..."
                }
                answerA.setTitle("A", for: .normal)
                answerB.setTitle("B", for: .normal)
                answerC.setTitle("C", for: .normal)
                answerD.setTitle("D", for: .normal)
                bubble1.isHidden = true
                bubble2.isHidden = true
                bubble3.isHidden = true
                bubble4.isHidden = true
                bubble1img.isHidden = true
                bubble2img.isHidden = true
                bubble3img.isHidden = true
                bubble4img.isHidden = true
                answerA.backgroundColor = .opaqueSeparator
                answerB.backgroundColor = .opaqueSeparator
                answerC.backgroundColor = .opaqueSeparator
                answerD.backgroundColor = .opaqueSeparator
                print(player1.score)
                print(player2.score)
                print(player3.score)
                print(player4.score)
            }
        }
        else {
            timeLabel.text = "0:00"
            timer.invalidate()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
