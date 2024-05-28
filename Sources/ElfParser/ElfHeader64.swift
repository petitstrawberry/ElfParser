import Foundation

public struct ElfHeader64 {
    public var e_ident: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
    public var e_type: UInt16
    public var e_machine: UInt16
    public var e_version: UInt32
    public var e_entry: UInt64
    public var e_phoff: UInt64
    public var e_shoff: UInt64
    public var e_flags: UInt32
    public var e_ehsize: UInt16
    public var e_phentsize: UInt16
    public var e_phnum: UInt16
    public var e_shentsize: UInt16
    public var e_shnum: UInt16
    public var e_shstrndx: UInt16

    public init?(data: Data) {
        guard data.count >= MemoryLayout<ElfHeader64>.size else {
            return nil
        }
        self = data.withUnsafeBytes { pointer in
            pointer.load(as: ElfHeader64.self)
        }
    }
}
