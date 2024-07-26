//
//  Model.swift
//  Demo
//
//  Created by Steven Boynes on 6/19/24.
//

import Foundation
import SmoldotSwift

class Model: ObservableObject {

    // - Important: Chain specification files provided for demonstration purposes only.
    static var chains = ["polkadot","kusama","rococo","westend"].map({
        let url = Bundle.main.url(forResource: $0, withExtension: "json")!
        return try! Chain(specificationFile: url)
    })
    
    @Published var session = [Message]()
    
    var chain: Chain
    
    init(chain: Chain) {
        self.chain = chain
    }

    func connect() throws {
        try Client.shared.add(chain: &chain)
    }

    // Get responses from chain
    //
    // - Important: Session message array will grow unbounded
    //
    func getResponses() async throws {
        for try await response in Client.shared.responses(from: chain) {
            DispatchQueue.main.async {
                self.session.append( Message(string: response, type: .response) )
            }
        }
    }
    
    func send(request string: String) throws {
        let request = try JSONRPC2Request(string: string)
        try Client.shared.send(request: request, to: chain)
    
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(request)
        
        let message = Message(string: String(data: data, encoding: .utf8)!, type: .request)
        session.append(message)
    }
    
    func disconnect() throws {
        try Client.shared.remove(chain: &chain)
        session.removeAll()
    }
    
}


struct Message {
    var string: String
    var `type`: Type
    let timestamp = Date()
    
    enum `Type`: CustomStringConvertible {
        case request
        case response
        
        var description: String {
            switch self {
            case .request:
                return "Request"
            case .response:
                return "Response"
            }
        }
    }
}
