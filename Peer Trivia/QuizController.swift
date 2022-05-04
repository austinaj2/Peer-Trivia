//
//  QuizController.swift
//  Peer Trivia
//
//  Created by Yabby Yimer Wolle on 5/4/22.
//

import UIKit
import MultipeerConnectivity

class QuizController: UIViewController, MCSessionDelegate {
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
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }

    var player1 = Player()
    var player2 = Player()
    var player3 = Player()
    var player4 = Player()
    var localPeerID: MCPeerID!
    var session: MCSession!
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        final.isEnabled = false
        final.backgroundColor = .systemGray
        player1img.image = player1.img
        player1Lbl.text = player1.name
        player2img.image = player2.img
        player2Lbl.text = player2.name
        player3img.image = player3.img
        player3Lbl.text = player3.name
        player4img.image = player4.img
        player4Lbl.text = player4.name
        if player2.name == "Not connected..." {
            self.view.addSubview(player1img)
            for i in self.view.subviews {
                if let img = player1img {
                    if img == i {
//                        UIView.animate(withDuration: 3, delay: 1, options: [UIView.AnimationOptions.curveEaseIn], animations: {
//                            i.frame = CGRect(x: (self.view.frame.origin.x), y: self.view.frame.minY+70, width: i.frame.width, height: i.frame.height)
//                        }, completion: { _ in
//                            
//                        })

                    }
                }
            }
            player2img.isHidden = true
            player2Lbl.isHidden = true
            
        }
        if player3.name == "Not connected..." {
            player3img.isHidden = true
            player3Lbl.isHidden = true
        }
        if player4.name == "Not connected..." {
            player4img.isHidden = true
            player4Lbl.isHidden = true
        }
    }
    
    @IBAction func finalize(_ sender: UIButton) {
        if answerA.backgroundColor == .systemGreen || answerB.backgroundColor == .systemGreen || answerC.backgroundColor == .systemGreen || answerD.backgroundColor == .systemGreen {
            
        }
    }
    
    @IBAction func clickA(_ sender: UIButton) {
        if sender.backgroundColor == .opaqueSeparator {
            sender.backgroundColor = .systemGreen
            answerB.backgroundColor = .opaqueSeparator
            answerC.backgroundColor = .opaqueSeparator
            answerD.backgroundColor = .opaqueSeparator
            final.backgroundColor = .systemRed
            final.isEnabled = true
        }
        else {
            final.backgroundColor = .systemGray
            final.isEnabled = false
            sender.backgroundColor = .opaqueSeparator
        }
    }
    
    @IBAction func clickB(_ sender: UIButton) {
        if sender.backgroundColor == .opaqueSeparator {
            sender.backgroundColor = .systemGreen
            answerA.backgroundColor = .opaqueSeparator
            answerC.backgroundColor = .opaqueSeparator
            answerD.backgroundColor = .opaqueSeparator
            final.backgroundColor = .systemRed
            final.isEnabled = true
        }
        else {
            final.backgroundColor = .systemGray
            final.isEnabled = false
            sender.backgroundColor = .opaqueSeparator
        }
    }
    @IBAction func clickC(_ sender: UIButton) {
        if sender.backgroundColor == .opaqueSeparator {
            sender.backgroundColor = .systemGreen
            answerB.backgroundColor = .opaqueSeparator
            answerA.backgroundColor = .opaqueSeparator
            answerD.backgroundColor = .opaqueSeparator
            final.backgroundColor = .systemRed
            final.isEnabled = true
        }
        else {
            final.backgroundColor = .systemGray
            final.isEnabled = false
            sender.backgroundColor = .opaqueSeparator
        }
    }
    @IBAction func clickD(_ sender: UIButton) {
        if sender.backgroundColor == .opaqueSeparator {
            sender.backgroundColor = .systemGreen
            answerB.backgroundColor = .opaqueSeparator
            answerC.backgroundColor = .opaqueSeparator
            answerA.backgroundColor = .opaqueSeparator
            final.backgroundColor = .systemRed
            final.isEnabled = true
        }
        else {
            final.backgroundColor = .systemGray
            final.isEnabled = false
            sender.backgroundColor = .opaqueSeparator
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
