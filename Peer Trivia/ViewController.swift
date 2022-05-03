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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localPeerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: localPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        print("Connected to \(peerID.displayName)")
        session.connectPeer(peerID, withNearbyConnectionData: Data())
        print(session.connectedPeers)
        certificateHandler(true)
    }

    @IBAction func singleClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        if(multiplayer.isSelected==true) {
            multiplayer.isSelected.toggle()
        }
    }
    
    @IBAction func multiClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        if(singlePlayer.isSelected==true) {
            singlePlayer.isSelected.toggle()
        }
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
                print("Connected: \(peerID.displayName)")
            case .connecting:
                print("Connecting: \(peerID.displayName)")
            case .connected:
                print("Not Connected: \(peerID.displayName)")
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
        print("ok")
        print("DUDDDDDDDDEEEEEEEE!!!!\n\n\n\n\n")

    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("ok")
        print("DUDDDDDDDDEEEEEEEE!!!!\n\n\n\n\n")

    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("ok")
        print("DUDDDDDDDDEEEEEEEE!!!!\n\n\n\n\n")

    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("ok")
        print("DUDDDDDDDDEEEEEEEE!!!!\n\n\n\n\n")


    }
}

