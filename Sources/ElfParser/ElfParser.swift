import Foundation

public class ElfParser {
    private var data: Data

    // Elfファイルパスから初期化
    public init?(filePath: String) {
        guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            return nil
        }
        self.data = fileData
    }

    // Elfファイルデータから初期化
    public init(data: [UInt8]) {
        self.data = Data(data)
    }

    // Elfヘッダをパース
    public func parseElfHeader() -> ElfHeader32? {
        return ElfHeader32(data: data)
    }

    // プログラムヘッダをパース
    public func parseProgramHeaders(elfHeader: ElfHeader32) -> [ProgramHeader]? {
        var headers = [ProgramHeader]()
        let headerSize = Int(elfHeader.e_phentsize)
        let headerCount = Int(elfHeader.e_phnum)
        let offset = Int(elfHeader.e_phoff)

        for i in 0..<headerCount {
            let headerOffset = offset + i * headerSize
            guard let header = ProgramHeader(data: data, offset: headerOffset) else {
                return nil
            }
            headers.append(header)
        }

        return headers
    }

    // バイナリデータを抽出
    public func extractBinaryData(with programHeaders: [ProgramHeader]) -> [UInt32: [UInt8]] {
        var binaryData = [UInt32: [UInt8]]()

        for header in programHeaders {
            let offset = Int(header.p_offset)
            let size = Int(header.p_filesz)

            guard offset + size <= data.count else {
                continue
            }

            let segmentData = data.subdata(in: offset..<(offset + size))
            binaryData[header.p_vaddr] = [UInt8](segmentData)
        }

        return binaryData
    }
}
