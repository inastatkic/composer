// Created by Ina Statkic in 2021.

import Foundation

extension FileManager {
    
    /// Home Directory
    public var homeURL: URL? {
        return URL(fileURLWithPath: NSHomeDirectory())
    }
    
    /// Document Directory
    /// User data
    public var documentsURL: URL? {
        let paths = urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
    }
}
