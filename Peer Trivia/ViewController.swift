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
    var peerID: MCPeerID!
    var connections = 0
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    @IBOutlet weak var singlePlayer: UIButton!
    @IBOutlet weak var connectivity: UIBarButtonItem!
    @IBOutlet weak var multiplayer: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.browser = MCBrowserViewController(serviceType: "chat", session: session)
        self.assistant = MCAdvertiserAssistant(serviceType: "chat", discoveryInfo: nil, session: session)
        
        assistant.start()
        assistant.delegate = self
        browser.delegate = self
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
        print("connected to \(peerID)")
        
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
        present(browser, animated: true, completion: nil)
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
        print(advertiserAssistant.session.myPeerID)
        advertiserAssistant.session.connectPeer(advertiserAssistant.session.myPeerID, withNearbyConnectionData: Data())
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

