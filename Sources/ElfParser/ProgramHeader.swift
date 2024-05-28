import Foundation

struct ProgramHeader {
    var p_type: UInt32
    var p_offset: UInt32
    var p_vaddr: UInt32
    var p_paddr: UInt32
    var p_filesz: UInt32
    var p_memsz: UInt32
    var p_flags: UInt32
    var p_align: UInt32

    init?(data: Data, offset: Int) {
        guard data.count >= offset + MemoryLayout<ProgramHeader>.size else {
            return nil
        }
        self = data.withUnsafeBytes { pointer in
            pointer.load(fromByteOffset: offset, as: ProgramHeader.self)
        }
    }
}
