
import Foundation
import Network

extension ViewController {
   func startListening() {
      listener = try? NWListener(using: .udp, on: udpPort)
      //listener?.service = NWListener.Service.init(type: "_appname._udp")
      
      self.listener?.stateUpdateHandler = { update in
         switch update {
         case .failed: print("listener stateUpdateHandler: update failed")
         default:      print("listener stateUpdateHandler: default update")
         }
      }
      
      self.listener?.newConnectionHandler = { [weak self] newConnection in
         print("newConnectionHandler:", newConnection)
         self?.createConnection(connection: newConnection)
         self?.listener?.cancel()
      }
      listener?.start(queue: .main)
   }
   
   func stopListening() {
      listener?.cancel()
      connection?.cancel()
   }
   
   func createConnection(connection: NWConnection) {
      self.connection = connection
      self.connection?.stateUpdateHandler = { [weak self] newState in
         switch (newState) {
         case .ready:     print("connection stateUpdateHandler: ready")
            self?.receive(on: connection)
         case .setup:     print("connection stateUpdateHandler: setup")
         case .cancelled: print("connection stateUpdateHandler: cancelled")
         case .preparing: print("connection stateUpdateHandler: preparing")
         default:         print("connection stateUpdateHandler: waiting or failed")
         }
      }
      self.connection?.start(queue: .global())
   }
   
   func receive(on connection: NWConnection?) {
      connection?.receiveMessage { [weak self] data, context, isComplete, error in
         if (isComplete) {
            if let data = data {
               let byteArray: [UInt8] = data.map { $0 }
               self?.parseBytes(array: byteArray)
            } else {
               print("receiveMessage: data == nil")
            }
         } else {
            print("receiveMessage: not complete")
         }
         self?.receive(on: connection)
      }
   }
}

extension ViewController {
   func parseBytes(array: [UInt8]) {
      // [68, 65, 84, 65, 42, 19, 0, 0, 0, 2, 11, 170, 66, 32, 112, 157, 192, 0, 192, 121, 196, 0, 192, 121, 196, 0, 192, 121, 196, 0, 192, 121, 196, 0, 192, 121, 196, 0, 192, 121, 196, 20, 0, 0, 0, 188, 77, 51, 66, 11, 89, 162, 65, 49, 165, 169, 67, 197, 185, 127, 62, 0, 0, 0, 0, 56, 165, 169, 67, 0, 0, 50, 66, 0, 0, 160, 65]
      // 68, 65, 84, 65, 42 = D,A,T,A,'': First 4 of the 5 prolouge bytes are the message type, like "DATA", fifth byte of prolouge is an "internal-use" byte
      // 19, 0, 0, 0 - 19 is the index corresponding to a data set index in X-Plane, eg. data set: "18: pitch, roll, headings"
      // Next 32 bytes make up a 8 single-precision floating point number (4 bytes per number)
      
      let prologueSize   = 5
      let datasetSize    = 36
      let bytesPerNumber = 4
      
      // Drop first 5 bytes (5 prolouge)
      let payload = Array(array.dropFirst(prologueSize))
         .chunked(into: datasetSize)
      
      for ds in payload {
         guard let row = ds.first else { continue }
         let chunks = Array(ds[(prologueSize - 1)..<datasetSize]).chunked(into: bytesPerNumber)
         let values = chunks.map { data in
            data.withUnsafeBytes {
               $0.load(as: Float32.self)
            }
         }
         //print(column, ":", values)
         // 19 : [85.02289, -4.919937, -999.0, -999.0, -999.0, -999.0, -999.0, -999.0]
         // 20 : [44.825912, 20.293478, 339.2952, 0.254495, 0.0, 339.295, 44.5, 20.0]
         DispatchQueue.main.async { [weak self] in
            self?.updateDisplayWithDataset(Int(row), values: values)
         }
      }
   }
}

// MARK: -

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
