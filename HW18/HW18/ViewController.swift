//
//  ViewController.swift
//  HW18
//
//  Created by Artem Mazurkevich on 16.03.2022.
//

import UIKit
import KeychainSwift

class ViewController: UIViewController {
    
    private var addedImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onAddPhotoButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @IBAction func onShowPhotosButton(_ sender: Any) {
        let galleryVC = GalleryViewController()
        galleryVC.delegate = self
        presentViewControllerWithSecurityCheck(viewController: galleryVC)
    }
    
    @IBAction func onSettingsButton(_ sender: Any) {
        let settingsVC = SettingsViewController()
        presentViewControllerWithSecurityCheck(viewController: settingsVC)
    }
    
    private func presentViewControllerWithSecurityCheck(viewController: UIViewController) {
        let keychain = KeychainSwift()
        if let passcode = keychain.get(KeychainKey.galleryPasscode.rawValue) {
            presentEnterPasscodeAlert(passcode: passcode, viewController: viewController)
        } else {
            present(viewController, animated: true)
        }
    }
    
    private func presentEnterPasscodeAlert(passcode: String, viewController: UIViewController) {
        let enterPasscodeAlert = UIAlertController(title: "Please enter your Passcode", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        enterPasscodeAlert.addTextField { (passcodeTextField) in
            passcodeTextField.placeholder = "Passcode"
            passcodeTextField.isSecureTextEntry = true
        }
        
        enterPasscodeAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        enterPasscodeAlert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
            if let textFieldValue = enterPasscodeAlert.textFields?.first?.text {
                if textFieldValue == passcode {
                    self.present(viewController, animated: true)
                }
            }
        })
        
        present(enterPasscodeAlert, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            addedImages.append(pickedImage)
        }
        
        picker.dismiss(animated: true)
    }
}

extension ViewController: GalleryDelegate {
    var images: [UIImage] {
        return addedImages
    }
}
