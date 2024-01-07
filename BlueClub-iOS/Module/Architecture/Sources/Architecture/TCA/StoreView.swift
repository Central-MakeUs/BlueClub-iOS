// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import ComposableArchitecture

public protocol StoreView: View {
    
    associatedtype Reducer: ComposableArchitecture.Reducer
    associatedtype Store: StoreOf<Reducer>
    associatedtype ViewStore: ViewStoreOf<Reducer>
    
    var store: Store { get }
    var viewStore: ViewStore { get }
}
