## Smoldot Swift Example

An Xcode workspace example for developing the [Smoldot Swift](https://github.com/finsig/smoldot-swift) package.

Swift Package targets can contain Swift, Objective-C/C++, or C/C++ code. But an individual target cannot mix Swift with C-family languages.

To overcome this limitation, the Smoldot Swift package consists of three targets: a Swift target, a C-only target, and an XCFramework target that contains the static C library compiled using a Rust FFI.

The C-only target serves as a bridge between Swift and C, allowing the package to access the C header methods of the static library.

A shell script is provided to build the XCFramework from the Rust FFI code.

## Usage

Clone the repo to your local machine.

```zsh
$ git clone --recurse-submodules https://github.com/finsig/smoldot-swift-example
```

Run the shell script to build, copy, and link the xcframework to the example app project.

```zsh
$ cd smoldot-swift-example
$ zsh build_submodule.sh
```

## Shell Script

The shell script updates the Smoldot Swift submodule to the head of the main branch and builds the XCframework for use in the Smoldot Swift Example project.

During this time the [Smoldot C FFI](https://github.com/finsig/smoldot-c-ffi) Rust repository is checked out to:

```zsh
.build/checkouts/smoldot-c-ffi
```

After building static C language binary archive files an xcframework is built and copied into the package. The package settings are modified to use the newly built file as a binary target.



## Notes

Incoming and outgoing Network Connections are enabled for the MacOS App Sandbox in XCode.

``Targets > SmoldotSwiftExample > Signing & Capabilities > App Sandbox``

Environment variables set in scheme settings:

```zsh
RUST_LOG=info
```

```zsh
IDEPreferLogStreaming=YES
```

See [GitHub Issues](https://github.com/finsig/smoldot-swift/issues) regarding console pane log noise.
