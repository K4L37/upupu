//
//  CameraController.swift
//  Upupu
//
//  Created by Toshiki Takeuchi on 8/29/16.
//  Copyright © 2016 Xcoo, Inc. All rights reserved.
//  See LISENCE for Upupu's licensing information.
//

import UIKit

import InAppSettingsKit
import SwiftyDropbox

class CameraController: UINavigationController, CameraViewControllerDelegate,
UploadViewControllerDelegate, IASKSettingsDelegate {

    private var cameraViewController: CameraViewController!
    private var uploadViewController: UploadViewController!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
        initialize()
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    private func initialize() {
        cameraViewController = CameraViewController(nibName: "CameraViewController", bundle: nil)
        cameraViewController.delegate = self

        uploadViewController = UploadViewController(nibName: "UploadViewController", bundle: nil)
        uploadViewController.delegate = self

        navigationBar.barStyle = UIBarStyle.BlackOpaque
        navigationBar.hidden = true

        pushViewController(cameraViewController, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func shouldAutorotate() -> Bool {
        return UIDevice.currentDevice().orientation == .Portrait
    }

    // MARK: - CameraViewControllerDelegate

    func cameraViewController(cameraViewController: CameraViewController,
                              didFinishedWithImage image: UIImage?) {
        uploadViewController.image = image
        uploadViewController.shouldSavePhotoAlbum = !cameraViewController.isSourcePhotoLibrary

        let application = UIApplication.sharedApplication()
        application.setStatusBarHidden(false, withAnimation: .Fade)
        application.statusBarStyle = .LightContent

        pushViewController(uploadViewController, animated: true)
    }

    // MARK: - UploadViewControllerDelegate

    func uploadViewControllerDidReturn(uploadViewController: UploadViewController) {
        dispatch_async(dispatch_get_main_queue()) {
            let application = UIApplication.sharedApplication()
            application.setStatusBarHidden(true, withAnimation: .Fade)
            application.statusBarStyle = .Default
        }

        popViewControllerAnimated(true)
    }

    func uploadViewControllerDidFinished(uploadViewController: UploadViewController) {
        dispatch_async(dispatch_get_main_queue()) {
            let application = UIApplication.sharedApplication()
            application.setStatusBarHidden(true, withAnimation: .Fade)
            application.statusBarStyle = .Default
        }

        popViewControllerAnimated(true)
    }

    func uploadViewControllerDidSetup(uploadViewController: UploadViewController) {
        let settingsViewController = IASKAppSettingsViewController()
        settingsViewController.delegate = self
        settingsViewController.showCreditsFooter = false

        let navigationContoller = UINavigationController(rootViewController: settingsViewController)
        navigationContoller.modalTransitionStyle = .FlipHorizontal

        let application = UIApplication.sharedApplication()
        application.setStatusBarHidden(false, withAnimation: .Fade)
        application.setStatusBarStyle(.Default, animated: true)
        presentViewController(navigationContoller, animated: true, completion: nil)
    }

    // MARK: - IASKSettingsDelegate

    func settingsViewControllerDidEnd(sender: IASKAppSettingsViewController) {
        let application = UIApplication.sharedApplication()
        application.setStatusBarHidden(false, withAnimation: .Fade)
        application.setStatusBarStyle(.LightContent, animated: true)
        sender.dismissViewControllerAnimated(true, completion: nil)
    }

    func settingsViewController(sender: IASKAppSettingsViewController,
                                buttonTappedForSpecifier specifier: IASKSpecifier) {
        if specifier.key() == "dropbox_link_pref" {
            if Dropbox.authorizedClient == nil {
                Dropbox.authorizeFromController(self)
                sender.dismissViewControllerAnimated(true, completion: nil)
            } else {
                Dropbox.unlinkClient()
                Settings.dropboxEnabled = false
                Settings.dropboxLinkButtonTitle = "Connect to Dropbox"
                Settings.dropboxAccount = ""
            }
        }
    }

}