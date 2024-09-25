import PassKit
import UIKit
import CoreData

public enum CardError: Error  {
   case DEVICE_IS_NOT_ELIGIBLE_TO_ADD_CARD,
   CARD_ALREADY_EXIST_ON_WALLET,
   UNKNOWN_ERROR
}

public class AppleWalletController : UIViewController {
    // STEP 1 check if wallet is available on device
    public func isWalletAvailable() async -> Bool {
        return PKPassLibrary.isPassLibraryAvailable()
    }
    
    // STEP 2 Check if card already exist in wallet to avoid duplications
    public func isCardAlreadyExists(serialNumber: String) -> Bool {
        let library = PKPassLibrary()
        let passes = library.passes(of: .secureElement)
        for pass in passes where pass.serialNumber == serialNumber {
            return true
        }
        return false
    }
    
    public func isAvailableToAddCardInAppleWallet(serialNumber: String) async throws -> Bool {
        let isDeviceAvailable = await isWalletAvailable();
        
        if !isDeviceAvailable {
            throw CardError.DEVICE_IS_NOT_ELIGIBLE_TO_ADD_CARD
        }
        
        let cardExists =  isCardAlreadyExists(serialNumber: serialNumber)
        if cardExists {
            throw CardError.CARD_ALREADY_EXIST_ON_WALLET
        }
        return true
    }
    
    public func isOpenPaymentSetup() {
        PKPassLibrary().openPaymentSetup()
    }

}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupApplePayButton()
    }

    private func setupApplePayButton() {
        let passKitButton = PKAddPassButton(addPassButtonStyle: .blackOutline)
        passKitButton.addTarget(self, action: #selector(onEnroll), for: .touchUpInside)
        view.addSubview(passKitButton)
        passKitButton.translatesAutoresizingMaskIntoConstraints = false
        passKitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        passKitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        passKitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
    }
    
    @objc private func onEnroll(button: UIButton) {
        // 1
        guard isPassKitAvailable() else {
            showPassKitUnavailable(message: "InApp enrollment not available for this device")
            return
        }
        // 2
        initEnrollProcess()
    }
    
    /**
     Init enrollment process
     */
    private func initEnrollProcess() {
        let card = cardInformation()
        guard let configuration = PKAddPaymentPassRequestConfiguration(encryptionScheme: .ECC_V2) else {
            showPassKitUnavailable(message: "InApp enrollment configuraton fails")
            return
        }
        configuration.cardholderName = card.holder
        configuration.primaryAccountSuffix = card.panTokenSuffix
        
        guard let enrollViewController = PKAddPaymentPassViewController(requestConfiguration: configuration, delegate: self) else {
            showPassKitUnavailable(message: "InApp enrollment controller configuration fails")
            return
        }
        
     
        present(enrollViewController, animated: true, completion: nil)
    }
    
    /**
     Define if PassKit will be available for this device
     */
    private func isPassKitAvailable() -> Bool {
        return PKAddPaymentPassViewController.canAddPaymentPass()
    }
    
    /**
     Show an alert that indicates that PassKit isn't available for this device
     */
    private func showPassKitUnavailable(message: String) {
        let alert = UIAlertController(title: "InApp Error",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     Return the card information that Apple will display into enrollment screen
     */
    private func cardInformation() -> Card {
        return Card(panTokenSuffix: "1234", holder: "Carl Jonshon")
    }
}

private struct Card {
    /// Last four digits of the `pan token` numeration for the card (****-****-****-0000)
    let panTokenSuffix: String
    /// Holder for the card
    let holder: String
}

extension ViewController: PKAddPaymentPassViewControllerDelegate {
    func addPaymentPassViewController(
        _ controller: PKAddPaymentPassViewController,
        generateRequestWithCertificateChain certificates: [Data],
        nonce: Data, nonceSignature: Data,
        completionHandler handler: @escaping (PKAddPaymentPassRequest) -> Void) {
        
        // Perform the bridge from Apple -> Issuer -> Apple
    }
    
    func addPaymentPassViewController(
        _ controller: PKAddPaymentPassViewController,
        didFinishAdding pass: PKPaymentPass?,
        error: Error?) {
        // This method will be called when enroll process ends (with success / error)
    }
}


