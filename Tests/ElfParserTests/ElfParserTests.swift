import XCTest
@testable import ElfParser

final class ElfParserTests: XCTestCase {

    // テスト用の簡単なElfデータ
    let elfTestData: [UInt8] = [
        0x7f, 0x45, 0x4c, 0x46, // e_ident (Elf magic number)
        0x01, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // e_ident (rest)
        0x02, 0x00, // e_type
        0x03, 0x00, // e_machine
        0x01, 0x00, 0x00, 0x00, // e_version
        0x80, 0x00, 0x00, 0x00, // e_entry
        0x34, 0x00, 0x00, 0x00, // e_phoff
        0x00, 0x00, 0x00, 0x00, // e_shoff
        0x00, 0x00, 0x00, 0x00, // e_flags
        0x34, 0x00, // e_ehsize
        0x20, 0x00, // e_phentsize
        0x01, 0x00, // e_phnum
        0x00, 0x00, // e_shentsize
        0x00, 0x00, // e_shnum
        0x00, 0x00, // e_shstrndx
        // プログラムヘッダ
        0x01, 0x00, 0x00, 0x00, // p_type
        0x54, 0x00, 0x00, 0x00, // p_offset
        0x80, 0x00, 0x00, 0x00, // p_vaddr
        0x80, 0x00, 0x00, 0x00, // p_paddr
        0x08, 0x00, 0x00, 0x00, // p_filesz
        0x08, 0x00, 0x00, 0x00, // p_memsz
        0x00, 0x00, 0x00, 0x00, // p_flags
        0x00, 0x10, 0x00, 0x00, // p_align
        // セグメントデータ
        0xde, 0xad, 0xbe, 0xef, 0xba, 0xad, 0xf0, 0x0d // 実データ
    ]

    func testElfHeader32Parsing() {
        let parser = ElfParser(data: elfTestData)
        let elfHeader = parser.parseElfHeader()
        XCTAssertNotNil(elfHeader)
        XCTAssertEqual(elfHeader?.e_entry, 0x80)
        XCTAssertEqual(elfHeader?.e_phoff, 0x34)
        XCTAssertEqual(elfHeader?.e_phnum, 1)
    }

    func testProgramHeaderParsing() {
        let parser = ElfParser(data: elfTestData)
        guard let elfHeader = parser.parseElfHeader() else {
            XCTFail("Failed to parse Elf header")
            return
        }

        let programHeaders = parser.parseProgramHeaders(elfHeader: elfHeader)
        XCTAssertNotNil(programHeaders)
        XCTAssertEqual(programHeaders?.count, 1)

        if let firstHeader = programHeaders?.first {
            XCTAssertEqual(firstHeader.p_type, 1)
            XCTAssertEqual(firstHeader.p_offset, 0x54)
            XCTAssertEqual(firstHeader.p_vaddr, 0x80)
            XCTAssertEqual(firstHeader.p_paddr, 0x80)
            XCTAssertEqual(firstHeader.p_filesz, 8)
            XCTAssertEqual(firstHeader.p_memsz, 8)
            XCTAssertEqual(firstHeader.p_flags, 0)
            XCTAssertEqual(firstHeader.p_align, 0x1000)
        } else {
            XCTFail("Failed to get program header")
        }
    }

    func testBinaryDataExtraction() {
        let parser = ElfParser(data: elfTestData)
        guard let elfHeader = parser.parseElfHeader() else {
            XCTFail("Failed to parse Elf header")
            return
        }

        guard let programHeaders = parser.parseProgramHeaders(elfHeader: elfHeader) else {
            XCTFail("Failed to parse program headers")
            return
        }

        let binaryData = parser.extractBinaryData(with: programHeaders)
        XCTAssertNotNil(binaryData)
        XCTAssertEqual(binaryData.count, 1)

        if let (address, data) = binaryData.first {
            XCTAssertEqual(address, 0x80)
            XCTAssertEqual(data, [0xde, 0xad, 0xbe, 0xef, 0xba, 0xad, 0xf0, 0x0d])
        } else {
            XCTFail("Failed to get binary data")
        }
    }

    static var allTests = [
        ("testElfHeader32Parsing", testElfHeader32Parsing),
        ("testProgramHeaderParsing", testProgramHeaderParsing),
        ("testBinaryDataExtraction", testBinaryDataExtraction),
    ]
}
