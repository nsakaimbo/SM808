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

struct StandardError: TextOutputStream {
  func write(_ str: String) {
    guard let data = str.data(using: .utf8) else { return }
    FileHandle.standardError.write(data)
  }
}

struct StandardOutput: TextOutputStream {
  func write(_ str: String) {
    guard let data = str.data(using: .utf8) else { return }
    FileHandle.standardOutput.write(data)
  }
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
  
  func write(_ message: String, separator: String = " ", terminator: String = "\n", to stream: OutputType = .standard) {
    
    switch stream {
    case .standard:
      var handle = StandardOutput()
      print(message, separator: separator, terminator: terminator, to: &handle)
    case .error:
      var handle = StandardError()
      print(message, separator: separator, terminator: terminator, to: &handle)
    }
    
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
