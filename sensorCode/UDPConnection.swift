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
  
  func connected() {
    let netmon = NWPathMonitor()
    netmon.start(queue: .main)
    let look = netmon.currentPath
    print("connected",look)
  }
  
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
  
//  func connectToUDP(hostUDP:NWEndpoint.Host,portUDP:NWEndpoint.Port) {
  func connectToUDP(hostUDP:NWEndpoint.Host,portUDP:NWEndpoint.Port) {
    let messageToUDP = "online"
    
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
  
  
  

  
  func sendUDP(_ content: Data) {
    self.connection?.send(content: content, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
      if (NWError != nil) {
//        print("Data was sent to UDP")
        self.receiveUDPV2()
      } else {
        print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
      }
    })))
  }
  
  func sendUDP(_ content: String) {
    let contentToSendUDP = content.data(using: String.Encoding.utf8)
    self.connection?.send(content: contentToSendUDP, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
      if (NWError == nil) {
//        print("Data was sent to UDP")
        self.receiveUDPV2()
      } else {
        print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
      }
    })))
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
          
        } else {
          print("Data == nil")
        }
      }
    }
  }
  
  
}
