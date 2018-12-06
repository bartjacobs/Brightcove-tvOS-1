//
//  ViewController.swift
//  AppleTV
//
//  Copyright © 2018 Brightcove. All rights reserved.
//

// This sample app shows how to set up and use the TV Player UI on tvOS.
// It also shows how to subclass BCOVTVTabBarItemView to create your
// own top tab bar item view with your own controls.

import AVKit
import AVFoundation
import BrightcovePlayerSDK

fileprivate struct playbackConfig {
    static let policyKey = "BCpkADawqM3n0ImwKortQqSZCgJMcyVbb8lJVwt0z16UD0a_h8MpEYcHyKbM8CGOPxBRp0nfSVdfokXBrUu3Sso7Nujv3dnLo0JxC_lNXCl88O7NJ0PR0z2AprnJ_Lwnq7nTcy1GBUrQPr5e"
    static let accountID = "4800266849001"
    static let videoID = "5754208017001"
}

class ViewController: UIViewController
{
    @IBOutlet weak var videoContainerView: UIView!
    
    lazy var playerView: BCOVTVPlayerView? = {
        // Set ourself as the presenting view controller
        // so that tab bar panels can present other view controllers
        let options = BCOVTVPlayerViewOptions()
        options.presentingViewController = self
        
        // Create and add to the video container view
        guard let _playerView = BCOVTVPlayerView(options: options) else {
            return nil
        }
        
        // Link the playback controller to the Player View
        _playerView.playbackController = playbackController
        
        videoContainerView.addSubview(_playerView)
        
        _playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _playerView.topAnchor.constraint(equalTo: videoContainerView.topAnchor),
            _playerView.rightAnchor.constraint(equalTo: videoContainerView.rightAnchor),
            _playerView.leftAnchor.constraint(equalTo: videoContainerView.leftAnchor),
            _playerView.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor)
        ])
        
        return _playerView
    }()
    
    lazy var playbackService: BCOVPlaybackService = {
        return BCOVPlaybackService(accountId: playbackConfig.accountID, policyKey: playbackConfig.policyKey)
    }()
    
    lazy var playbackController: BCOVPlaybackController? = {
        guard let _playbackController = BCOVPlayerSDKManager.shared().createPlaybackController() else {
            return nil
        }
        _playbackController.delegate = self
        _playbackController.isAutoAdvance = true
        _playbackController.isAutoPlay = true
        return _playbackController
    }()
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        createSampleTabBarItemView()
        requestContentFromPlaybackService()
    }

    private func createSampleTabBarItemView() {
        
        guard let playerView = playerView, var topTabBarItemViews = playerView.settingsView.topTabBarItemViews else {
            return
        }
        
        let sampleTabBarItemView = SampleTabBarItemView(size: CGSize.init(width: 620, height: 200), playerView: playerView)
        
        // Insert our new tab bar item view at the end of the top tab bar
        topTabBarItemViews.append(sampleTabBarItemView)
        playerView.settingsView.topTabBarItemViews = topTabBarItemViews
    }

    private func requestContentFromPlaybackService() {
        playbackService.findVideo(withVideoID: playbackConfig.videoID, parameters: nil) { [weak self] (video: BCOVVideo?, jsonResponse: [AnyHashable: Any]?, error: Error?) -> Void in
            
            if let _video = video {
                //  since "isAutoPlay" is true, setVideos will begin playing the content
                self?.playbackController?.setVideos([_video] as NSArray)
            } else {
                print("ViewController Debug - Error retrieving video: \(error?.localizedDescription ?? "unknown error")")
            }
            
        }
    }
  
}

// MARK: - UIFocusEnvironment overrides

extension ViewController {
    
    // Focus Environment override for tvOS 9
    override var preferredFocusedView: UIView? {
        return playerView
    }
    
    // Focus Environment override for tvOS 10+
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return (playerView != nil ? [ playerView! ] : [])
    }
    
}

// MARK: - BCOVPlaybackControllerDelegate

extension ViewController: BCOVPlaybackControllerDelegate {
    
    func playbackController(_ controller: BCOVPlaybackController!, didAdvanceTo session: BCOVPlaybackSession!) {
        NSLog("ViewController Debug - Advanced to new session.")
    }
    
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didReceive lifecycleEvent: BCOVPlaybackSessionLifecycleEvent!) {
        NSLog("Event: %@", lifecycleEvent.eventType)
        
        switch lifecycleEvent.eventType {
        case kBCOVPlaybackSessionLifecycleEventReady:
            guard let playerItem = session.player.currentItem else {
                return
            }
            
            // Set External Metadata
            playerItem.externalMetadata = createExternalMetadata()
        default:
            break
        }
    }
    
    // MARK: -
    
    private func createExternalMetadata() -> [AVMetadataItem] {
        // Create Buffer
        var metadata = [AVMetadataItem]()
        
        // Create Metadata Item for Title
        if let title = metadataItem(identifier: .commonIdentifierTitle, value: "Some Title") {
            metadata.append(title)
        }

        return metadata
    }
    
    private func metadataItem(identifier: AVMetadataIdentifier, value: Any) -> AVMetadataItem? {
        // Create Mutable Metadata Item
        let item = AVMutableMetadataItem()
        
        // Configure Mutable Metadata Item
        item.identifier = identifier
        item.extendedLanguageTag = "und"
        item.value = value as? NSCopying & NSObjectProtocol
        
        return item.copy() as? AVMetadataItem
    }

}
