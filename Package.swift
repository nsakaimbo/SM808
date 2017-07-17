import PackageDescription

let package = Package(
  name: "SM808",
  targets: [
    Target(
      name: "SM808",
      dependencies: ["SM808Core"]
    ),
    Target(name: "SM808Core")
  ]
)

