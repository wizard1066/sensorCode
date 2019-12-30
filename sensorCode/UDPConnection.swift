//
//  UDPConnection.swift
//  speakCode
//
//  Created by localadmin on 15.11.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import Foundation
import Network

protocol speaker {
  func speak(_ comm:String, para:String)
}

class connect: NSObject {


  
  var connection: NWConnection?
  var listen: NWListener?
  var spoken: speaker?
  var missing: lostLink?
  
  func listenUDP() {
    do {
      let port = NWEndpoint.Port.init(port2G!.description)
      self.listen = try NWListener(using: .udp, on: port!)
      self.listen?.service = NWListener.Service(name: "talkCode", type: "_tc._udp", domain: nil, txtRecord: nil)
      
      self.listen?.stateUpdateHandler = {(newState) in
        switch newState {
        case .ready:
          print("Server ready.")
        case .failed(let error):
          print("Server failure, error: \(error.localizedDescription)")
          exit(EXIT_FAILURE)
        default:
          break
        }
      }
      self.listen?.newConnectionHandler = {(newConnection) in
        newConnection.stateUpdateHandler = {newState in
          switch newState {
          case .ready:
            self.receive(on: newConnection)
            print("newConnection", newConnection.endpoint, newConnection.currentPath?.localEndpoint)
          case .failed(let error):
            print("client failed with error: \(error)")
          case .cancelled:
            print("Cancelled connection")
          default:
            break
          }
        }
        newConnection.start(queue: DispatchQueue(label: "new client"))
      }
    } catch {
      print("not listening")
    }
    self.listen?.start(queue: .main)
  }
  
  func stopListening() {
    self.listen?.cancel()
  }
  
  func receive(on connection: NWConnection) {
    
    connection.receiveMessage { (data, context, isComplete, error) in
      if let error = error {
        print(error)
        return
      }
      if let data = data, !data.isEmpty {
        let backToString = String(decoding: data, as: UTF8.self)
//        print("context",context?.protocolMetadata)
        self.spoken?.speak(backToString, para: backToString)
      }
      connection.send(content: "ok".data(using: .utf8), completion: .contentProcessed({error in
        if let error = error {
          print("error while sending data: \(error)")
          return
        }
      }))
      self.receive(on: connection)
    }
  }
  
  private var portX: NWEndpoint.Port?
  private var hostX: NWEndpoint.Host?
  
  func reconnect() {
    if hostX == nil || portX == nil { return }
    connectToUDP(hostUDP:hostX!,portUDP:portX!)
  }
  
//  func connectToUDP(hostUDP:NWEndpoint.Host,portUDP:NWEndpoint.Port) {
  func connectToUDP(hostUDP:NWEndpoint.Host,portUDP:NWEndpoint.Port) {
    hostX = hostUDP
    portX = portUDP
    
    
    
    var messageToUDP = simple(online:"online")
    
    self.connection?.viabilityUpdateHandler = { (isViable) in
      if (!isViable) {
      
        print("connection viable")
        // display error
      } else {
        print("no connection")
        return
        // display ok
      }
    }
    
    self.connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)
    self.connection?.parameters.prohibitedInterfaceTypes = [ .cellular ]
    self.connection?.stateUpdateHandler = { (newState) in
      
      switch (newState) {
      case .ready:
        
        self.sendUDP(messageToUDP)
      //                self.receiveUDP()
      case .setup:
        print("State: Setup\n")
      case .cancelled:
        print("State: Cancelled\n")
      case .preparing:
        print("State: Preparing\n")
      case .failed(_):
        print("Failed")
      default:
        print("ERROR! State not defined!\n")
      }
    }
    
    self.connection?.betterPathUpdateHandler = { (betterPathAvailable) in
      if (betterPathAvailable) {
        // code
      } else {
        // code
      }
    }
    //    self.connection?.start(queue: .global())
    self.connection?.start(queue: .main)
    
  }
  
 var connectedStatus: Bool {
  guard let connect = self.connection?.state else { return false }
  if connect == .preparing || connect == .ready {
    return true
  } else {
    return false
  }
 }
  
  func disconnectUDP() {
    self.connection?.cancel()
  }
  
  func sendUDP(_ content: Data) {
    self.connection?.send(content: content, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
      if (NWError == nil) {
        
//        print("Data was sent to UDP")
//        self.receiveUDPV2()
      } else {
        print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!) \(self.missing)")
        self.missing?.sendAlert(error: NWError!.debugDescription)
      }
    })))
  }
  
  func sendUDP(_ content: String) {
    if pulse! { return }
    do {
      let encoder = JSONEncoder()
      let jsonData = try encoder.encode(content)
      let jsonString = String(data: jsonData, encoding: .utf8)!
      let contentToSendUDP = jsonString.data(using: String.Encoding.utf8)
      
//     let contentToSendUDP = content.data(using: String.Encoding.utf8)
      self.connection?.send(content: contentToSendUDP, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
        if (NWError == nil) {
          // code
        } else {
          print("ERROR! Error when data (Type: String) sending. NWError: \n \(NWError!) ")
          self.missing?.sendAlert(error: NWError!.debugDescription)
        }
      })))
    } catch {
      print("error",error)
    }
  }
  
  func sendUDP(_ content: simple) {
    if pulse! { return }
    do {
      let encoder = JSONEncoder()
      let jsonData = try encoder.encode(content)
      let jsonString = String(data: jsonData, encoding: .utf8)!
      let contentToSendUDP = jsonString.data(using: String.Encoding.utf8)
      sendUDP(contentToSendUDP!)
    } catch {
      print("error",error)
    }
  }
  
  func sendUDP(_ content: neighbours) {
    if pulse! { return }
    do {
      let encoder = JSONEncoder()
      let jsonData = try encoder.encode(content)
      let jsonString = String(data: jsonData, encoding: .utf8)!
      let contentToSendUDP = jsonString.data(using: String.Encoding.utf8)
      sendUDP(contentToSendUDP!)
    } catch {
      print("error",error)
    }
  }
  
  func sendUDP(_ content: voice) {
    if pulse! { return }
    do {
      let encoder = JSONEncoder()
      let jsonData = try encoder.encode(content)
      let jsonString = String(data: jsonData, encoding: .utf8)!
      let contentToSendUDP = jsonString.data(using: String.Encoding.utf8)
      sendUDP(contentToSendUDP!)
    } catch {
      print("error",error)
    }
  }
  
  func sendUDP(_ content: fly) {
    if pulse! { return }
    do {
      let encoder = JSONEncoder()
      let jsonData = try encoder.encode(content)
      let jsonString = String(data: jsonData, encoding: .utf8)!
      let contentToSendUDP = jsonString.data(using: String.Encoding.utf8)
      sendUDP(contentToSendUDP!)
    } catch {
      print("error",error)
    }
  }
  
  func sendUDP(_ content: gps) {
    if pulse! { return }
    do {
      let encoder = JSONEncoder()
      let jsonData = try encoder.encode(content)
      let jsonString = String(data: jsonData, encoding: .utf8)!
      let contentToSendUDP = jsonString.data(using: String.Encoding.utf8)
      sendUDP(contentToSendUDP!)
    } catch {
      print("error",error)
    }
  }
  
  func sendUDP(_ content: globe) {
    if pulse! { return }
    do {
      let encoder = JSONEncoder()
      let jsonData = try encoder.encode(content)
      let jsonString = String(data: jsonData, encoding: .utf8)!
      let contentToSendUDP = jsonString.data(using: String.Encoding.utf8)
      sendUDP(contentToSendUDP!)
    } catch {
      print("error",error)
    }
  }
  
  var word: String?
  
  func pulseUDP2(_ content: pulser2) {
    
    // put this in cause speaking will send multiple copies of the same word
    do {
      let encoder = JSONEncoder()
      var newContent = content
      if newContent.word == word {
        newContent.word = ""
      }
      let jsonData = try encoder.encode(newContent)
      let jsonString = String(data: jsonData, encoding: .utf8)!
      let contentToSendUDP = jsonString.data(using: String.Encoding.utf8)
      self.connection?.send(content: contentToSendUDP, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
        if (NWError == nil) {
          self.word = content.word
        } else {
          print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
        }
      })))
    } catch {
      print("error",error)
    }
  }
  
  func pulseUDP(_ content: pulser) {
    
    // put this in cause speaking will send multiple copies of the same word
    do {
      let encoder = JSONEncoder()
      var newContent = content
      if newContent.word == word {
        newContent.word = nil
      }
      let jsonData = try encoder.encode(newContent)
      let jsonString = String(data: jsonData, encoding: .utf8)!
      let contentToSendUDP = jsonString.data(using: String.Encoding.utf8)
      self.connection?.send(content: contentToSendUDP, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
        if (NWError == nil) {
          self.word = content.word
        } else {
          print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
        }
      })))
    } catch {
      print("error",error)
    }
  }
  
  func receiveUDP() {
    self.connection?.receive(minimumIncompleteLength: 1, maximumLength: 65536, completion: { (data, context, isComplete, error) in
      if let data = data, !data.isEmpty {
        print("did receive \(data.count) bytes")
      }
    })
  }
  
  func receiveUDPV2() {
    self.connection?.receiveMessage { (data, context, isComplete, error) in
      if (isComplete) {
        
        if (data != nil) {
          let backToString = String(decoding: data!, as: UTF8.self)
          print("recieved ",backToString)
        } else {
          print("Data == nil")
        }
      }
    }
  }
  
  
}



class NetStatus {
  static let shared = NetStatus()
  
  var isConnected: Bool {
      guard let monitor = monitor else { return false }
      return monitor.currentPath.status == .satisfied
  }
  
  var interfaceType: NWInterface.InterfaceType? {
      guard let monitor = monitor else { return nil }
   
      return monitor.currentPath.availableInterfaces.filter {
          monitor.currentPath.usesInterfaceType($0.type) }.first?.type
  }
  
  var availableInterfacesTypes: [NWInterface.InterfaceType]? {
      guard let monitor = monitor else { return nil }
      return monitor.currentPath.availableInterfaces.map { $0.type }
  }
  
  var isExpensive: Bool {
      return monitor?.currentPath.isExpensive ?? false
  }
  
  private init() {
    
  }
  
  deinit {
      stopMonitoring()
  }
  
  var monitor: NWPathMonitor?
  
  var isMonitoring = false
  
  var didStartMonitoringHandler: (() -> Void)?
   
  var didStopMonitoringHandler: (() -> Void)?
   
  var netStatusChangeHandler: (() -> Void)?
  
  func startMonitoring() {
    guard !isMonitoring else { return }
    monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetStatus_Monitor")
    monitor?.start(queue: queue)
    monitor?.pathUpdateHandler = { _ in
        self.netStatusChangeHandler?()
    }
    isMonitoring = true
    didStartMonitoringHandler?()
  }
  
  func stopMonitoring() {
    guard isMonitoring, let monitor = monitor else { return }
    monitor.cancel()
    self.monitor =  nil
    isMonitoring = false
    didStopMonitoringHandler?()
  }
  
  func getInfo() {
    guard isMonitoring, let monitor = monitor else { return }
    print(monitor.currentPath.availableInterfaces)
    
  }
  
}
