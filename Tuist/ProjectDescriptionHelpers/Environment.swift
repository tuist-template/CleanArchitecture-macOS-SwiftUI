import ProjectDescription

public enum Environment {
    public static let appName = ""
    public static let targetName = ""
    public static let targetTestName = "\(targetName)Tests"
    public static let organizationName = "JiHoonAHN"
    public static let deploymentTarget: DeploymentTarget = .macOS(targetVersion: "11.0")
    public static let platform = Platform.macOS
    public static let baseSetting: SettingsDictionary = SettingsDictionary()
}
