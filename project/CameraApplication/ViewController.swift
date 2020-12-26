//
//  ViewController.swift
//  CameraApplication
//
//  Created by Christian Quicano on 2/24/16.
//  Copyright © 2016 ecorenetworks. All rights reserved.
//

import UIKit
import CQZCameraManager

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showActionSheetCamera(sender: AnyObject) {
        CQZCameraManager.shared.showActionSheetSelectImage(inViewController: self
            , allowsEditing: false
            , showCameraFrontal: true
            , titleAlert: nil
            , titleSourceCamera: "Take Picture"
            , titleSourceLibrary: "Select Picture"
            , completion: { [weak self] (image, isFromGallerySelector) -> () in
                if let image = image {
                    self?.imageView.image = image
                    print("get image")
                    print("isFromGallerySelector: \(isFromGallerySelector)")
                }else{
                    print("cancel")
                }
            }
            , moreActions: nil)
    }

    @IBAction func changeAllowsEditing(sender: UISwitch) {
        CQZCameraManager.shared.allowsEditing = sender.isOn
    }
}

