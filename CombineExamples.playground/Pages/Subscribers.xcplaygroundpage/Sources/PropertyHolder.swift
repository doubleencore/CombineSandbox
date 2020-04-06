import Foundation

public class PropertyHolder {
    public var property = 0 {
        didSet {
            print("set property value to \(property)")
        }
    }

    public init() {}
}
