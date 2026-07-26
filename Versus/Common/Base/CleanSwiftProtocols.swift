//
//  CleanSwiftProtocols.swift
//  Versus
//

import Foundation

protocol DataStore: AnyObject {}

protocol DataPassing: AnyObject {
    var dataStore: DataStore? { get }
}
