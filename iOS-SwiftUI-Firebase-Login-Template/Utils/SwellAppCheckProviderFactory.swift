//
//  SwellAppCheckProviderFactory.swift
//  Swell
//
//  Created by Tanner Maasen on 12/10/22.
//

import Firebase

class SwellAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
//#if DEBUG
//     let debugProvider = AppCheckDebugProvider(app: app)
//     // You can access debug token using the debugProvider.localDebugToken API!
//      debugPrint(debugProvider?.localDebugToken())
//      return debugProvider
//#endif
    if #available(iOS 14.0, *) {
      return AppAttestProvider(app: app)
    } else {
      return DeviceCheckProvider(app: app)
    }
  }
}
