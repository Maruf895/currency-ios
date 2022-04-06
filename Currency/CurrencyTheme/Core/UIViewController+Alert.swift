import Foundation
import UIKit

public extension UIViewController {

    func alert(message: String, title: String = "", oKAction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: oKAction)

        alertController.addAction(OKAction)

        present(alertController, animated: true, completion: nil)
    }

    func alertWithTwoAction(message: String, title: String = "", okButtonTitle: String = "", cancelButtonTitle: String = "", OKAction: ((UIAlertAction) -> Void)? = nil, cancelaction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okButtonTitle, style: .default, handler: OKAction)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelaction)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func noInternetConnection() {
        alertWithTwoAction(message: Alerts.noInternetOpenSetting, title: "", okButtonTitle: ButtonTitle.settings, cancelButtonTitle: ButtonTitle.cancel, OKAction: { (_) in
            guard let urlString = URL(string: UIApplication.openSettingsURLString) else {return}
            UIApplication.shared.open(urlString, options: [:], completionHandler: nil)
        })
    }
    
    func showLoader() {
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
    }
}
