import Foundation

struct ElfHeader64 {
    var e_ident: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
    var e_type: UInt16
    var e_machine: UInt16
    var e_version: UInt32
    var e_entry: UInt64
    var e_phoff: UInt64
    var e_shoff: UInt64
    var e_flags: UInt32
    var e_ehsize: UInt16
    var e_phentsize: UInt16
    var e_phnum: UInt16
    var e_shentsize: UInt16
    var e_shnum: UInt16
    var e_shstrndx: UInt16

    init?(data: Data) {
        guard data.count >= MemoryLayout<ElfHeader64>.size else {
            return nil
        }
        self = data.withUnsafeBytes { pointer in
            pointer.load(as: ElfHeader64.self)
        }
    }
}
