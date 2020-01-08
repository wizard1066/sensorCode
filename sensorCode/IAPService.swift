//
//  IAPService.swift
//  sensorCode
//
//  Created by localadmin on 13.12.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import Foundation
import StoreKit

protocol transaction {
  func feedback(service: String, message: String)
}

class IAPService: NSObject {
  
  private override init() {}
  static let shared = IAPService()
  
  var ordered:transaction?
  var products = [SKProduct]()
  let paymentQueue = SKPaymentQueue.default()
  
  func getProducts() {
    let products: Set = [IAPProduct.azimuth.rawValue,
                          IAPProduct.motion.rawValue,
                          IAPProduct.voice.rawValue,
                          IAPProduct.light.rawValue]
    let request = SKProductsRequest(productIdentifiers: products)
    request.delegate = self
    request.start()
    paymentQueue.add(self)
  }
  
  func purchase(product:IAPProduct) {
    guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue}).first else { return }
    let payment = SKPayment(product: productToPurchase)
    paymentQueue.add(payment)
  }
  
  func restorePurchases() {
    paymentQueue.restoreCompletedTransactions()
  }
  
}

extension IAPService: SKProductsRequestDelegate {

  func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    self.products = response.products
    for product in response.products {
      print(product.localizedTitle)
    }
  }
}

extension IAPService: SKPaymentTransactionObserver {
  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      switch transaction.transactionState {
        case .purchasing: break
        default: queue.finishTransaction(transaction)
      }
      ordered?.feedback(service: transaction.payment.productIdentifier, message: transaction.transactionState.status())
    }
  }
}

extension SKPaymentTransactionState {

  func status() -> String {
    switch self {
      case .deferred: return "Deferred"
      case .failed: return "Failed"
      case .purchased: return "Purchased"
      case .purchasing: return "Purchasing"
      case .restored: return "Restored"
      default: return "Unknown"
    }
  }
}
