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
    
    //MARK: - opens properties
    public var hasCamera:Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
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
    
    private var didFinishPickingImage:((_ image:UIImage?, _ isFromGallerySelector: Bool) -> ())?

    private var isFromGallerySelector = false
    
    //MARK: - override methods
    private override init(){
        super.init()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
    }
    
    
    //MARK: - open methods
    public func showCameraFrontal(onViewController viewController:UIViewController, completion: @escaping (_ image:UIImage?, _ isFromGallerySelector: Bool) -> ()) {
        imagePickerController.allowsEditing = true
        didFinishPickingImage = completion
        imagePickerController.sourceType = UIImagePickerController.SourceType.camera
        imagePickerController.showsCameraControls = true
        imagePickerController.cameraDevice = .front
        viewController.present(imagePickerController, animated: true, completion: nil)
    }
    
    public func showActionSheetSelectImage(inViewController viewController:UIViewController
        , allowsEditing:Bool
        , showCameraFrontal:Bool
        , titleAlert:String?
        , titleSourceCamera:String?
        , titleSourceLibrary:String?
        , completion: @escaping (_ image:UIImage?, _ isFromGallerySelector: Bool) -> ()
        , moreActions actions:[UIAlertAction]?) {
        
        imagePickerController.allowsEditing = allowsEditing
        if showCameraFrontal {
//            imagePickerController.cameraDevice = UIImagePickerControllerSourceType.camera
        }
        didFinishPickingImage = completion
        
        let alert = UIAlertController(title: titleAlert, message: nil, preferredStyle:UIAlertController.Style.actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let actionCamera = UIAlertAction(title: titleSourceCamera, style: UIAlertAction.Style.default, handler: { [unowned self] (action) -> Void in
                self.takePhoto(inViewController: viewController)
                })
            alert.addAction(actionCamera)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let actionGaleria = UIAlertAction(title: titleSourceLibrary, style: UIAlertAction.Style.default, handler: { [unowned self] (action) -> Void in
                self.selectPhoto(inViewController: viewController)
                })
            alert.addAction(actionGaleria)
        }
        
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.destructive) { (action) -> Void in
        }
        alert.addAction(actionCancel)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - private methods
    private func takePhoto(inViewController viewController:UIViewController) {
        isFromGallerySelector = false
        imagePickerController.sourceType = UIImagePickerController.SourceType.camera
        imagePickerController.showsCameraControls = true
        viewController.present(imagePickerController, animated: true, completion: nil)
    }
    
    private func selectPhoto(inViewController viewController:UIViewController) {
        isFromGallerySelector = true
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        viewController.present(imagePickerController, animated: true, completion: nil)
    }
    
    fileprivate func executeDidFinishPickingImage(image:UIImage?) {
        imagePickerController.dismiss(animated: true, completion: nil)
        if let didFinishPickingImage = didFinishPickingImage {
            didFinishPickingImage(image, isFromGallerySelector)
        }
        didFinishPickingImage = nil
    }
}

extension CQZCameraManager:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            executeDidFinishPickingImage(image: image)
        }else{
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                executeDidFinishPickingImage(image: image)
            }
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        executeDidFinishPickingImage(image: nil)
    }
    
}
