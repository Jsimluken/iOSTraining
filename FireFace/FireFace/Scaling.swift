//
//  Scaling.swift
//  AML
//
//  Created by hiroki moriguchi on 2019/10/02.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import Foundation
import CoreML


@objc(Scaling) class Scaling: NSObject, MLCustomLayer {
    func setWeightData(_ weights: [Data]) throws {
        print(#function, weights)
    }
    
    func outputShapes(forInputShapes inputShapes: [[NSNumber]]) throws -> [[NSNumber]] {
        print(#function, inputShapes)
        return inputShapes
    }
    
    func evaluate(inputs: [MLMultiArray], outputs: [MLMultiArray]) throws {
        print(#function, inputs.count, outputs.count)
    }
    
    required init(parameters: [String : Any]) throws {
      print(#function, parameters)
      super.init()
    }
}
