//
//  ChainRPCView.swift
//  Demo
//
//  Created by Steven Boynes on 6/20/24.
//

import SwiftUI
import SmoldotSwift

struct RPCView: View {
    
    @StateObject private var model: Model
    
    @State private var request: String = .empty
    @State private var runtimeErrorMessage: String = .empty
    @State private var showingAlert = false
    
    init(chain: Chain) {
        _model = StateObject(wrappedValue: Model(chain: chain))
    }

    var body: some View {
        VStack {
            ScrollView {
                ForEach(model.session, id: \.string) { message in
                    Divider()
                    Text(String(describing: message.type) + " - " + String(describing: message.timestamp))
                        .foregroundStyle(.primary)
                        .font(.footnote)
                        .italic()
                        .padding(.bottom)
                    Text(message.string)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom)
                }
            }
            .defaultScrollAnchor(.bottom)
            .scrollIndicatorsFlash(onAppear: true)
            .navigationTitle(model.chain.specification.name)
            .toolbar {
                #if os(iOS)
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            model.session.removeAll()
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                #else
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            model.session.removeAll()
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                #endif
            }
            
            HStack {
                RequestMenuView(request: $request)
                
                TextField(text: $request, prompt: Text("JSON-RPC2 Request String"), label: { Text(verbatim: .empty) })
                    .textFieldStyle(.roundedBorder)
                
                if request.count > .zero {
                    Button {
                        do {
                            try model.send(request: request)
                            request = .empty
                        }
                        catch {
                            runtimeErrorMessage = String(describing: error)
                            showingAlert.toggle()
                        }
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .foregroundStyle(.white, .polkadotGreen)
                            .frame(width: 44.0, height: 44.0)
                    }
                }
            }
            .padding()
        }
        .onAppear(perform: {
            do {
                try model.connect()
            }
            catch {
                runtimeErrorMessage = String(describing: error)
                showingAlert.toggle()
            }
        })
        .onDisappear(perform: {
            try? model.disconnect()
        })
        .alert(runtimeErrorMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
        .task {
            do {
                try await model.getResponses()
            }
            catch {
                runtimeErrorMessage = String(describing: error)
            }
        }
    }
    
}


fileprivate struct RequestMenuView: View {
    
    @Binding var request: String
    
    @State private var identifier: Int = .zero
    
    @State private var isBuilderPresented = false
    @State private var method = ""
    @State private var parameters = ""
    
    var body: some View {
        Menu {
            Button("Build request...", action: { isBuilderPresented.toggle() })
            Button("system_chain", action: systemChain)
            Button("chain_get_header", action: chainGetHeader)
            Button("chain_subscribe_new_heads", action: chainSubscribeNewHeads)
        } label: {
            #if os(iOS)
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .foregroundStyle(.white, .polkadotPink)
                    .frame(width: 44.0, height: 44.0)
            #else
                Label("Requests", systemImage: "plus.circle.fill")
                    .foregroundColor(.secondary)
                    .labelStyle(.titleOnly)
            #endif
        }
        .menuStyle(.button)
        .menuOrder(.fixed)
        .alert("Build Request", isPresented: $isBuilderPresented) {
            #if os(iOS)
                TextField("Method", text: $method)
                    .foregroundColor(.black)
                    .autocapitalization(.none)
                TextField("Parameters", text: $parameters)
                    .foregroundColor(.black)
                    .autocapitalization(.none)
            #else
                TextField("Method", text: $method)
                    .foregroundColor(.primary)
                TextField("Parameters", text: $parameters)
                    .foregroundColor(.primary)
            #endif
            Button("OK", action: buildRequest)
            Button("Cancel", role: .cancel) { }
        }
    }
    
    func buildRequest() {
        request = "{\"id\":\(nextIdentifier),\"jsonrpc\":\"2.0\",\"method\":\"\(method)\",\"params\":[\(parameters)]}"
    }
    
    func systemChain() {
        request = "{\"id\":\(nextIdentifier),\"jsonrpc\":\"2.0\",\"method\":\"system_chain\",\"params\":[]}"
    }
    
    func chainGetHeader() {
        request = "{\"id\":\(nextIdentifier),\"jsonrpc\":\"2.0\",\"method\":\"chain_getHeader\",\"params\":[]}"
    }
    func chainSubscribeNewHeads() {
        request = "{\"id\":\(nextIdentifier),\"jsonrpc\":\"2.0\",\"method\":\"chain_subscribeNewHeads\",\"params\":[]}"
    }
    
    var nextIdentifier: Int {
        identifier += 1
        return identifier
    }
}

fileprivate extension String {
    static let empty = ""
}
