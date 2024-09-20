import PassKit
import UIKit
import CoreData

public enum CardError: Error  {
   case DEVICE_IS_NOT_ELIGIBLE_TO_ADD_CARD,
   CARD_ALREADY_EXIST_ON_WALLET,
   UNKNOWN_ERROR
}

public class AppleWalletController {
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
}



