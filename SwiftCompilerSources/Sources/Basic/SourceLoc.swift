//===--- SourceLoc.swift - SourceLoc bridiging utilities ------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

public struct SourceLoc {
  /// Points into a source file.
  public let bridged: swift.SourceLoc

  public init(bridged: swift.SourceLoc) {
    self.bridged = bridged
  }
}

extension SourceLoc {
  public func advanced(by n: Int) -> SourceLoc {
    SourceLoc(bridged: bridged.getAdvancedLoc(Int32(n)))
  }
}

extension Optional where Wrapped == SourceLoc {
  public var bridged: swift.SourceLoc {
    self?.bridged ?? .init(llvm.SMLoc.getFromPointer(nil))
  }
}

public struct CharSourceRange {
  private let start: SourceLoc
  private let byteLength: Int

  public init(start: SourceLoc, byteLength: Int) {
    self.start = start
    self.byteLength = byteLength
  }

  public init?(bridged: BridgedCharSourceRange) {
    self.init(start: SourceLoc(bridged: bridged.start), byteLength: bridged.byteLength)
  }

  public var bridged: BridgedCharSourceRange {
    .init(start: start.bridged, byteLength: byteLength)
  }
}

extension Optional where Wrapped == CharSourceRange {
  public var bridged: BridgedCharSourceRange {
    self?.bridged ?? .init(start: .init(llvm.SMLoc.getFromPointer(nil)), byteLength: 0)
  }
}
