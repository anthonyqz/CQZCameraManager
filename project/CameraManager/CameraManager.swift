//
//  CameraManager.swift
//  CameraManager
//
//  Created by Christian Quicano on 2/24/16.
//  Copyright © 2016 ecorenetworks. All rights reserved.
//

import Foundation
import UIKit

public class CQZCameraManager:NSObject {
    
    //MARK: - Singleton
    public static let shared = CQZCameraManager()
    
    //MARK: - publics properties
    public var hasCamera:Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    public var allowsEditing:Bool {
        get {
            return imagePickerController.allowsEditing
        }
        set {
            imagePickerController.allowsEditing = newValue
        }
    }
    
    //MARK: - privates properties
    private let imagePickerController = UIImagePickerController()
    
    private var didFinishPickingImage:((image:UIImage?) -> ())?
    
    //MARK: - override methods
    private override init(){
        super.init()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
    }
    
    
    //MARK: - public methods
    public func showActionSheetSelectImage(inViewController viewController:UIViewController, allowsEditing:Bool, titleAlert:String?, titleSourceCamera:String?, titleSourceLibrary:String?, completion: (image:UIImage?) -> (), moreActions actions:[UIAlertAction]?) {
        
        imagePickerController.allowsEditing = allowsEditing
        didFinishPickingImage = completion
        
        let alert = UIAlertController(title: titleAlert, message: nil, preferredStyle:UIAlertControllerStyle.ActionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let actionCamera = UIAlertAction(title: titleSourceCamera, style: UIAlertActionStyle.Default, handler: { [unowned self] (action) -> Void in
                self.takePhoto(inViewController: viewController)
                })
            alert.addAction(actionCamera)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let actionGaleria = UIAlertAction(title: titleSourceLibrary, style: UIAlertActionStyle.Default, handler: { [unowned self] (action) -> Void in
                    self.selectPhoto(inViewController: viewController)
                })
            alert.addAction(actionGaleria)
        }
        
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Destructive) { (action) -> Void in
        }
        alert.addAction(actionCancel)
        
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: - private methods
    private func takePhoto(inViewController viewController:UIViewController) {
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        imagePickerController.showsCameraControls = true
        viewController.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    private func selectPhoto(inViewController viewController:UIViewController) {
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        viewController.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    private func executeDidFinishPickingImage(image:UIImage?) {
        imagePickerController.dismissViewControllerAnimated(true, completion: nil)
        if let didFinishPickingImage = didFinishPickingImage {
            didFinishPickingImage(image: image)
        }
        didFinishPickingImage = nil
    }
}

extension CQZCameraManager:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            executeDidFinishPickingImage(image)
        }else{
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                executeDidFinishPickingImage(image)
            }
        }
    }
    
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        executeDidFinishPickingImage(nil)
    }
}


















