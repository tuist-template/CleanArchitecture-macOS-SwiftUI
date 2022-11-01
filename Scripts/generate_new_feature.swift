#!/usr/bin/swift
import Foundation

func make_new_feature(_ feature_name : String,_ has_demo: Bool = false) {
    make_dir("\(feature_name)Feature")
    make_project_file(feature_name, "\(feature_name)Feature", has_demo)
    make_sources(feature_name)
    make_tests(feature_name)
    if has_demo {
        make_demo(feature_name)
    }
}

func write_code_in_file(_ file_path: String,_ codes: String) {
    if let data: Data = codes.data(using: .utf8) {
        do {
            try data.write(to: URL(fileURLWithPath: current_path + file_path))
        } catch let e {
            print("⚠️ Error - \(e.localizedDescription)")
        }
    }
}

func make_dir(_ path: String) {
    do {
        try fileManager.createDirectory(atPath: current_path+path, withIntermediateDirectories: false, attributes: nil)
    } catch let e {
        print("⚠️ Error - \(e.localizedDescription)")
    }
}

func make_dirs(_ paths: [String]) {
    paths.forEach{
        make_dir($0)
    }
}

func make_project_file(_ feature_name : String,_ file_path: String,_ has_demo : Bool = false,_ dependencies: [String] = []) {
    let project_path = file_path + "/Project.swift"
    let _ = file_path.split(separator: "/")
    let file_content = """
    import ProjectDescription
    import ProjectDescriptionHelpers
    
    let project = Project.makeModule(
        name: "\(feature_name)Feature",
        product: .staticFramework,
        dependencies: [
            .Project.Feature.CommonFeature,
        ]\(has_demo ? ",\n  hasDemo: true" : "")
    )
    """
    write_code_in_file(project_path, file_content)
}

func make_sources(_ feature_name: String) {
    make_dir("\(feature_name)Feature/Sources")
    let feature_file_path = "\(feature_name)Feature/Sources/\(feature_name)Feature.swift"
    let feature_content = "// This is for tuist"
    write_code_in_file(feature_file_path, feature_content)
}

func make_tests(_ feature_name: String) {
    make_dir("\(feature_name)Feature/Tests")
    let test_file_path = "\(feature_name)Feature/Tests/TargetTests.swift"
    let test_content = """
import XCTest

class TargetTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssertEqual("A", "A")
    }

}
"""
    write_code_in_file(test_file_path, test_content)
}
func make_demo(_ feature_name: String) {
    make_dir("\(feature_name)Feature/Demo")
    make_dir("\(feature_name)Feature/Demo/Sources")
    
    let app_delegate_path = "\(feature_name)Feature/Demo/Sources/\(feature_name)App.swift"
    let app_delegate = """
    import SwiftUI

    @main
    struct \(feature_name)FeatureApp: App {
        var body: some Scene {
            WindowGroup {
                \(feature_name)View()
            }
        }
    }
    """
    write_code_in_file(app_delegate_path, app_delegate)
}

print("Input new feature name : ", terminator: "")
let feature_name : String = readLine()?.replacingOccurrences(of: "\n", with: "") ?? ""

print("Include demo? (Y or N, default = N) : ", terminator: "")
let has_demo : Bool = readLine()?.replacingOccurrences(of: "\n", with: "").uppercased() == "Y"


print("Start to generate the new feature named \(feature_name)...")

let current_path : String = "./Projects/Features/"
let fileManager : FileManager = .default

make_new_feature(feature_name, has_demo)
