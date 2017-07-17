//
//  ConsoleIO.swift
//  SM808
//
//  Created by Nicholas Sakaimbo on 7/15/17.
//
//

import Foundation

/// Represents the choice of output stream
///
/// - error: Standard Error (stderr)
/// - standard: Standard Output (stdout)
enum OutputType {
  case error
  case standard
}

protocol IOProviding {
  func getInput() -> String
  func write(_ message: String, separator: String, terminator: String, to stream: OutputType)
}

extension IOProviding {
  
  func getInput() -> String {
    let keyboard = FileHandle.standardInput
    let inputData = keyboard.availableData
    let strData = String(data: inputData, encoding: String.Encoding.utf8)!
    return strData.trimmingCharacters(in: CharacterSet.newlines)
  }
  
  func _write(_ str: String, to stream: OutputType) {
    
    let handle: FileHandle
    
    switch stream {
    case .standard:
      handle = FileHandle.standardOutput
    case .error:
      handle = FileHandle.standardError
    }
    if let data = str.data(using: .utf8) {
      handle.write(data)
    }
  }
  
  func write(_ message: String, separator: String = " ", terminator: String = "\n", to stream: OutputType = .standard) {
    let str = message + separator + terminator
    _write(str, to: stream)
  }
}

extension IOProviding {
  
  func getCommand(_ input: String) -> Command? {
    
    do {
      let command = try Command(input)
      return command
    }
    catch let error as Command.Error {
      write(error.localizedDescription, to: .error)
      return nil
    }
    catch {
      write("Undefined error occurred with input: \(input)", to: .error)
      return nil
    }
  }
  
}

final class ConsoleIO: IOProviding { }
