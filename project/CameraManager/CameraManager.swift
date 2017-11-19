//
//  CameraManager.swift
//  CameraManager
//
//  Created by Christian Quicano on 2/24/16.
//  Copyright © 2016 ecorenetworks. All rights reserved.
//

import Foundation
import UIKit

open class CQZCameraManager:NSObject {
    
    //MARK: - Singleton
    open static let shared = CQZCameraManager()
    
    //MARK: - opens properties
    open var hasCamera:Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    
    open var allowsEditing:Bool {
        get {
            return imagePickerController.allowsEditing
        }
        set {
            imagePickerController.allowsEditing = newValue
        }
    }
    
    //MARK: - privates properties
    private let imagePickerController = UIImagePickerController()
    
    private var didFinishPickingImage:((_ image:UIImage?) -> ())?
    
    //MARK: - override methods
    private override init(){
        super.init()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
    }
    
    
    //MARK: - open methods
    open func showCameraFrontal(onViewController viewController:UIViewController, completion: @escaping (_ image:UIImage?) -> ()) {
        imagePickerController.allowsEditing = true
        didFinishPickingImage = completion
        imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
        imagePickerController.showsCameraControls = true
        imagePickerController.cameraDevice = .front
        viewController.present(imagePickerController, animated: true, completion: nil)
    }
    
    open func showActionSheetSelectImage(inViewController viewController:UIViewController
        , allowsEditing:Bool
        , showCameraFrontal:Bool
        , titleAlert:String?
        , titleSourceCamera:String?
        , titleSourceLibrary:String?
        , completion: @escaping (_ image:UIImage?) -> ()
        , moreActions actions:[UIAlertAction]?) {
        
        imagePickerController.allowsEditing = allowsEditing
        if showCameraFrontal {
//            imagePickerController.cameraDevice = UIImagePickerControllerSourceType.camera
        }
        didFinishPickingImage = completion
        
        let alert = UIAlertController(title: titleAlert, message: nil, preferredStyle:UIAlertControllerStyle.actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let actionCamera = UIAlertAction(title: titleSourceCamera, style: UIAlertActionStyle.default, handler: { [unowned self] (action) -> Void in
                self.takePhoto(inViewController: viewController)
                })
            alert.addAction(actionCamera)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let actionGaleria = UIAlertAction(title: titleSourceLibrary, style: UIAlertActionStyle.default, handler: { [unowned self] (action) -> Void in
                self.selectPhoto(inViewController: viewController)
                })
            alert.addAction(actionGaleria)
        }
        
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.destructive) { (action) -> Void in
        }
        alert.addAction(actionCancel)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - private methods
    private func takePhoto(inViewController viewController:UIViewController) {
        imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
        imagePickerController.showsCameraControls = true
        viewController.present(imagePickerController, animated: true, completion: nil)
    }
    
    private func selectPhoto(inViewController viewController:UIViewController) {
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        viewController.present(imagePickerController, animated: true, completion: nil)
    }
    
    fileprivate func executeDidFinishPickingImage(image:UIImage?) {
        imagePickerController.dismiss(animated: true, completion: nil)
        if let didFinishPickingImage = didFinishPickingImage {
            didFinishPickingImage(image)
        }
        didFinishPickingImage = nil
    }
}

extension CQZCameraManager:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            executeDidFinishPickingImage(image: image)
        }else{
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                executeDidFinishPickingImage(image: image)
            }
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        executeDidFinishPickingImage(image: nil)
    }
    
}
