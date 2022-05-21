//
//  ViewController.swift
//  HW18
//
//  Created by Artem Mazurkevich on 16.03.2022.
//

import UIKit

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
        present(galleryVC, animated: true)
    }
    @IBAction func onSettingsButton(_ sender: Any) {
        let settingsVC = SettingsViewController()
        present(settingsVC, animated: true)
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
