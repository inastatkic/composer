// Created by Ina Statkic in 2021.

import Foundation
import SwiftUI

extension Sequence {
    /// Numbers the elements
    func numbered(start at: Int = 0) -> [(number: Int, element: Element)] {
        Array(zip(at..., self))
    }
}
