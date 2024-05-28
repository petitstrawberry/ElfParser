import Foundation

public struct ProgramHeader {
    public var p_type: UInt32
    public var p_offset: UInt32
    public var p_vaddr: UInt32
    public var p_paddr: UInt32
    public var p_filesz: UInt32
    public var p_memsz: UInt32
    public var p_flags: UInt32
    public var p_align: UInt32

    public init?(data: Data, offset: Int) {
        guard data.count >= offset + MemoryLayout<ProgramHeader>.size else {
            return nil
        }
        self = data.withUnsafeBytes { pointer in
            pointer.load(fromByteOffset: offset, as: ProgramHeader.self)
        }
    }
}
