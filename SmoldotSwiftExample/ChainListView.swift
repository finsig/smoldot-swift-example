//
//  ChainSpecificationView.swift
//  Demo
//
//  Created by Steven Boynes on 6/19/24.
//

import SwiftUI
import SmoldotSwift

struct ChainListView: View {
    
    let chains: [Chain] = [
        .polkadot,
        .kusama,
        .rococo,
        .westend
    ]
   
    var body: some View {
        NavigationStack {
            List(chains, id: \.specification.name) { chain in
                NavigationLink(chain.specification.name, value: chain)
            }
            .navigationDestination(for: Chain.self) { chain in
                RPCView(chain: chain)
            }
            .navigationTitle("Chain")
        }
    }
}
