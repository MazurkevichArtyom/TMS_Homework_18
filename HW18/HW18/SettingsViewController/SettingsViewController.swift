//
//  SettingsViewController.swift
//  HW18
//
//  Created by Artem Mazurkevich on 24.04.2022.
//

import UIKit
import KeychainSwift

class SettingsViewController: UIViewController {
    
    private var switcher = UISwitch()
    private var passcodeTextField: UITextField?
    private var confirmPasscodeTextField: UITextField?
    private var setupAction: UIAlertAction?
    
    override func loadView() {
        let customView = UIView(frame: UIScreen.main.bounds)
        customView.backgroundColor = .white
        view = customView
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let keychain = KeychainSwift()
        if let _ = keychain.get(KeychainKey.galleryPasscode.rawValue) {
            switcher.setOn(true, animated: false)
        }
    }
    
    private func setupUI() {
        let customNavigationBar = UINavigationBar()
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customNavigationBar)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDoneButton))
        let navigationItem = UINavigationItem(title: "Settings")
        navigationItem.rightBarButtonItem = doneButton
        customNavigationBar.items = [navigationItem]
        
        customNavigationBar.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let passwordLabel = UILabel()
        passwordLabel.text = "Passcode"
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordLabel)
        
        passwordLabel.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        passwordLabel.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: 20.0).isActive = true
        passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        passwordLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.addTarget(self, action: #selector(onSwitchVlaueChanged), for: .valueChanged)
        
        view.addSubview(switcher)
        
        switcher.centerYAnchor.constraint(equalTo: passwordLabel.centerYAnchor).isActive = true
        switcher.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0).isActive = true
        
    }
    
    @objc private func onDoneButton() {
        dismiss(animated: true)
    }
    
    @objc private func onSwitchVlaueChanged() {
        if !switcher.isOn {
            presentDeletePasscodeAlert()
        } else {
            presentSetupPasscodeAlert()
        }
    }
    
    private func presentSetupPasscodeAlert() {
        let passcodeOnAlert = UIAlertController(title: "Turn On Passcode?", message: "Please input your passcode for access in your gallery.", preferredStyle: UIAlertController.Style.alert)
        
        let setupAction = UIAlertAction(title: "Setup", style: .default) { _ in
            let keychain = KeychainSwift()
            if let passcode = passcodeOnAlert.textFields?.first?.text {
                keychain.set(passcode, forKey: KeychainKey.galleryPasscode.rawValue)
            }
            self.removeAllDependencies()
        }
        
        setupAction.isEnabled = false
        self.setupAction = setupAction
        
        passcodeOnAlert.addAction(setupAction)
        
        passcodeOnAlert.addTextField { passcodeTextField in
            passcodeTextField.placeholder = "Passcode"
            passcodeTextField.isSecureTextEntry = true
            passcodeTextField.addTarget(self, action: #selector(self.onPasscodeChanged), for: .editingChanged)
            self.passcodeTextField = passcodeTextField
        }
        
        passcodeOnAlert.addTextField { confirmPasscodeTextField in
            confirmPasscodeTextField.placeholder = "Confirm Passcode"
            confirmPasscodeTextField.isSecureTextEntry = true
            confirmPasscodeTextField.addTarget(self, action: #selector(self.onPasscodeChanged), for: .editingChanged)
            self.confirmPasscodeTextField = confirmPasscodeTextField
        }
        
        passcodeOnAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.switcher.setOn(false, animated: true)
            self.removeAllDependencies()
        })
        
        present(passcodeOnAlert, animated: true, completion: nil)
    }
    
    private func presentDeletePasscodeAlert() {
        let passcodeOffAlert = UIAlertController(title: "Turn Off Passcode?", message: "Are you sure want to remove passcode?", preferredStyle: UIAlertController.Style.alert)
        
        passcodeOffAlert.addAction(UIAlertAction(title: "Turn Off", style: .destructive) { _ in
            let keychain = KeychainSwift()
            keychain.delete(KeychainKey.galleryPasscode.rawValue)
            self.switcher.setOn(false, animated: true)
        })
        
        passcodeOffAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.switcher.setOn(true, animated: true)
        })
        
        present(passcodeOffAlert, animated: true, completion: nil)
    }
    
    @objc private func onPasscodeChanged() {
        guard let passcodeTextField = passcodeTextField else {
            return
        }
        
        guard let confirmPasscodeTextField = confirmPasscodeTextField else {
            return
        }
        
        if let setupAction = setupAction {
            setupAction.isEnabled = passcodeTextField.text == confirmPasscodeTextField.text && !(passcodeTextField.text?.isEmpty ?? true)
        }
    }
    
    private func removeAllDependencies() {
        if let passcodeTextField = passcodeTextField {
            passcodeTextField.removeTarget(self, action: #selector(onPasscodeChanged), for: .editingChanged)
        }
        
        if let confirmPasscodeTextField = confirmPasscodeTextField {
            confirmPasscodeTextField.removeTarget(self, action: #selector(onPasscodeChanged), for: .editingChanged)
        }
        
        passcodeTextField = nil
        confirmPasscodeTextField = nil
        setupAction = nil
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
