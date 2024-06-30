## Smoldot Swift Example

An Xcode workspace example for developing the [Smoldot Swift](https://github.com/finsig/smoldot-swift) package.

Swift Package targets can contain Swift, Objective-C/C++, or C/C++ code. But an individual target cannot mix Swift with C-family languages.

To overcome this limitation, the Smoldot Swift package consists of three targets: a Swift target, a C-only target, and an XCFramework target that contains the static C library compiled using a Rust FFI.

The C-only target serves as a bridge between Swift and C, allowing the package to access the C header methods of the static library.

A shell script is provided to build the XCFramework from the Rust FFI code.

## Usage

Clone the repo to your local machine.
```zsh
> git clone https://github.com/finsig/smoldot-swift-example
```
Run submodule update to checkout the package workspace inside the repo.

```zsh
> git submodule update –init –recursive
```

Run the shell script to build, copy, and link the xcframework to the example app project.

```zsh
> zsh build_xcframework.sh dev
```

## Shell Script

The shell script checks out the [Smoldot C FFI](https://github.com/finsig/smoldot-c-ffi) Rust repository to:
```zsh
.build/checkouts/smoldot-c-ffi
```

It then builds static C language binary archives for the iOS, Simulator, and MacOS architectures.

An XCode framework is built from the static libraries. 

The framework is copied into the package and the package is configured to use the local file as a binary target.

## Notes

Incoming and outgoing Network Connections are enabled for the MacOS App Sandbox in XCode.

``Targets > SmoldotSwiftExample > Signing & Capabilities > App Sandbox``

Environment variables set in scheme settings:

```zsh
RUST_LOG = info
```

```zsh
IDEPreferLogStreaming = YES
```

See [issues](https://github.com/finsig/smoldot-swift/issues) regarding console pane spam messages.
