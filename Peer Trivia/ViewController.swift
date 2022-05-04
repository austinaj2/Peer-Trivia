//
//  ViewController.swift
//  Peer Trivia
//
//  Created by Macky Cisse on 4/28/22.
//

import UIKit
import MultipeerConnectivity


class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCAdvertiserAssistantDelegate, MCSessionDelegate, UINavigationControllerDelegate  {
    
    var join: UIAlertController!
    var session: MCSession!
    var assistant: MCAdvertiserAssistant!
    var connections = 0
    var localPeerID: MCPeerID!
    var mcBrowser: MCBrowserViewController!
    @IBOutlet weak var singlePlayer: UIButton!
    @IBOutlet weak var connectivity: UIBarButtonItem!
    @IBOutlet weak var multiplayer: UIButton!
    @IBOutlet weak var player1img: UIImageView!
    @IBOutlet weak var player2img: UIImageView!
    @IBOutlet weak var player4img: UIImageView!
    @IBOutlet weak var player3img: UIImageView!
    @IBOutlet weak var player1Lbl: UILabel!
    @IBOutlet weak var player2Lbl: UILabel!
    @IBOutlet weak var player3Lbl: UILabel!
    @IBOutlet weak var player4Lbl: UILabel!
    @IBOutlet weak var start: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectivity.isEnabled = false
        connectivity.tintColor = .gray
        localPeerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: localPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        player1Lbl.text = "Me"
        player2Lbl.text = "Not connected..."
        player3Lbl.text = "Not connected..."
        player4Lbl.text = "Not connected..."
        player1img.isHidden = true
        player2img.isHidden = true
        player3img.isHidden = true
        player4img.isHidden = true
        player1Lbl.isHidden = true
        player2Lbl.isHidden = true
        player3Lbl.isHidden = true
        player4Lbl.isHidden = true
        start.tintColor = .gray
        start.isEnabled = false
    }
    
    /* Passing data through segue */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToQuiz" {
            if let nextVC = segue.destination as? QuizController {
                nextVC.player1 = Player(score: 0, img: player1img.image!, name: player1Lbl.text!)
                nextVC.player2 = Player(score: 0, img: player2img.image!, name: player2Lbl.text!)
                nextVC.player3 = Player(score: 0, img: player3img.image!, name: player3Lbl.text!)
                nextVC.player4 = Player(score: 0, img: player4img.image!, name: player4Lbl.text!)
                nextVC.session = session
                nextVC.localPeerID = localPeerID
            }
        }
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        if session.connectedPeers.count < 3 {
            certificateHandler(true)
        }
        else {
            certificateHandler(false)
        }
    }


    @IBAction func singleClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        if(multiplayer.isSelected==true) {
            multiplayer.isSelected.toggle()
        }
        if(connectivity.isEnabled==true) {
            connectivity.isEnabled = false
            connectivity.tintColor = .gray
        }
        if(session.connectedPeers.count==0) {
            start.isEnabled = true
            start.tintColor = .systemBlue
        }
        else {
            start.isEnabled = false
            start.tintColor = .gray
        }
        player1img.isHidden = true
        player2img.isHidden = true
        player3img.isHidden = true
        player4img.isHidden = true
        player1Lbl.isHidden = true
        player2Lbl.isHidden = true
        player3Lbl.isHidden = true
        player4Lbl.isHidden = true
    }
    
    @IBAction func startQuiz(_ sender: UIButton) {
        sender.isSelected.toggle()
        if singlePlayer.isSelected {
            self.performSegue(withIdentifier: "goToQuiz", sender: self)
        }
        if multiplayer.isSelected {
            if start.isSelected {
                self.performSegue(withIdentifier: "goToQuiz", sender: self)
            }
        }
    }
    
    @objc func nextPage() {
        performSegue(withIdentifier: "goToQuiz", sender: self)
    }
    
    @IBAction func multiClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        if(singlePlayer.isSelected==true) {
            singlePlayer.isSelected.toggle()
        }
        if(connectivity.isEnabled==false) {
            connectivity.isEnabled = true
            connectivity.tintColor = .systemBlue
        }
        if(session.connectedPeers.count>0) {
            start.isEnabled = true
            start.tintColor = .systemBlue
        }
        else {
            start.isEnabled = false
            start.tintColor = .gray
        }
        player1img.isHidden = false
        player2img.isHidden = false
        player3img.isHidden = false
        player4img.isHidden = false
        player1Lbl.isHidden = false
        player2Lbl.isHidden = false
        player3Lbl.isHidden = false
        player4Lbl.isHidden = false
    }
    
    @IBAction func connect(_ sender: UIBarButtonItem) {
        let sheet = UIAlertController(title: nil, message: "How do you want to connect?", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Host Session", style: .default, handler: { (action: UIAlertAction) in
            self.assistant = MCAdvertiserAssistant(serviceType: "chat", discoveryInfo: nil, session: self.session)
//            self.assistant.delegate = self
            self.assistant.start()
        }))
        sheet.addAction(UIAlertAction(title: "Join Session", style: .default, handler: { (action: UIAlertAction) in
            self.mcBrowser = MCBrowserViewController(serviceType: "chat", session: self.session)
            self.mcBrowser.delegate = self
            self.present(self.mcBrowser, animated: true, completion: nil)
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(sheet, animated: true, completion: nil)
    }
    
    /* required MCBrowser functions */
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .notConnected:
                print("Not connected: \(peerID.displayName)")
                if self.multiplayer.isSelected == true {
                    if(session.connectedPeers.count>0) {
                        self.start.isEnabled = true
                        self.start.tintColor = .systemBlue
                    }
                    else {
                        self.start.isEnabled = false
                        self.start.tintColor = .gray
                    }
                }
                if self.singlePlayer.isSelected == true {
                    if(session.connectedPeers.count==0) {
                        self.start.isEnabled = true
                        self.start.tintColor = .systemBlue
                    }
                    else {
                        self.start.isEnabled = false
                        self.start.tintColor = .gray
                    }
                }
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
                    self.player2Lbl.text = cons[0]
                    self.player3Lbl.text = cons[1]
                    self.player4Lbl.text = cons[2]
                    print(cons)
                }
                else {
                    self.player2Lbl.text = "Not connected..."
                    self.player3Lbl.text = "Not connected..."
                    self.player4Lbl.text = "Not connected..."
                }
                if self.player2Lbl.text == "Not connected..." {
                    self.player2img.image = UIImage(named: "white")
                }
                if self.player3Lbl.text == "Not connected..." {
                    self.player3img.image = UIImage(named: "white")
                }
                if self.player4Lbl.text == "Not connected..." {
                    self.player4img.image = UIImage(named: "white")
                }
            case .connecting:
                print("Connecting: \(peerID.displayName)")
            case .connected:
                print("Connected: \(peerID.displayName)")
                if self.multiplayer.isSelected == true {
                    if(session.connectedPeers.count>0) {
                        self.start.isEnabled = true
                        self.start.tintColor = .systemBlue
                    }
                    else {
                        self.start.isEnabled = false
                        self.start.tintColor = .gray
                    }
                }
                if self.singlePlayer.isSelected == true {
                    if(session.connectedPeers.count==0) {
                        self.start.isEnabled = true
                        self.start.tintColor = .systemBlue
                    }
                    else {
                        self.start.isEnabled = false
                        self.start.tintColor = .gray
                    }
                }
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
                    self.player2Lbl.text = cons[0]
                    self.player3Lbl.text = cons[1]
                    self.player4Lbl.text = cons[2]
                    print(cons)
                }
                if self.player2Lbl.text != "Not connected..." {
                    self.player2img.image = UIImage(named: "orange")
                }
                if self.player3Lbl.text != "Not connected..." {
                    self.player3img.image = UIImage(named: "pink")
                }
                if self.player4Lbl.text != "Not connected..." {
                    self.player4img.image = UIImage(named: "blue")
                }
            @unknown default:
                fatalError()
            }
        }
    }
        
    func advertiserAssistantWillPresentInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        
    }
    
    func advertiserAssistantDidDismissInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {


    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {


    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }
}

class Player {
    var score: Int
    var img: UIImage
    var name: String

    init() {
        self.score = 0
        self.img = UIImage()
        self.name = ""
    }
    
    init(score: Int, img: UIImage, name: String) {
        self.score = score
        self.img = img
        self.name = name
    }
}

