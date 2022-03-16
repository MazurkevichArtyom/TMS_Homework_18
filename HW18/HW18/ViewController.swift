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
        let alert = UIAlertController(title: "Info", message: "Coming soon...", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
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
