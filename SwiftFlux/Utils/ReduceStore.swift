//
//  ReduceStore.swift
//  SwiftFlux
//
//  Created by Kenichi Yonekawa on 11/18/15.
//  Copyright © 2015 mog2dev. All rights reserved.
//

import Result

open class ReduceStore<T: Equatable>: StoreBase {
    public init(initialState: T) {
        self.initialState = initialState
        super.init()
    }

    private var initialState: T
    private var internalState: T?
    public var state: T {
        return internalState ?? initialState
    }

    public func reduce<A: Action>(type: A.Type, reducer: @escaping (T, Result<A.Payload, A.ActionError>) -> T) -> DispatchToken {
        return self.register(type: type) { (result) in
            let startState = self.state
            self.internalState = reducer(self.state, result)
            if startState != self.state {
               self.emitChange()
            }
        }
    }
}
