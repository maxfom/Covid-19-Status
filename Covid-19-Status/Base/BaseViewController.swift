//
//  BaseViewController.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 25.07.2021.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension UIViewController {
    
    func showAlert(
        title: String?,
        message: String?,
        okButton: String,
        okAction: (() -> Void)?)
    {
        showAlert(
            title: title,
            message: message,
            cancelButton: okButton,
            cancelAction: okAction
        )
    }

    func showAlert(
        title: String?,
        message: String?,
        cancelButton: String,
        cancelAction: (() -> Void)? = nil,
        okButton: String? = nil,
        okAction: ((String?) -> Void)? = nil,
        hasTextField: Bool = false,
        textFieldText: String? = nil,
        textFieldPlaceholder: String? = nil)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var textField: UITextField?
        if hasTextField {
            alert.addTextField { tf in
                textField = tf
                tf.text = textFieldText
                tf.placeholder = textFieldPlaceholder
            }
        }
        
        if let okButtonTitle = okButton {
            let okButton = UIAlertAction(title: okButtonTitle, style: .default) { _ in
                okAction?(textField?.text)
            }
            alert.addAction(okButton)
        }
        
        let cancelButton = UIAlertAction(title: cancelButton, style: .cancel) { _ in
            cancelAction?()
        }
        alert.addAction(cancelButton)

        present(alert, animated: true, completion: nil)
    }

}
