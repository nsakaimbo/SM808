//
//  Command.swift
//  SM808
//
//  Created by Nicholas Sakaimbo on 7/16/17.
//
//

import Foundation

enum Command {
  case kick(pattern: String)
  case hihat(pattern: String)
  case snare(pattern: String)
  case play
  case preset
  case quit
  
  init?(_ input: String) throws {
    
    let inputs = input.components(separatedBy: CharacterSet.whitespaces)
    
    let command = inputs[0]
    let arguments:[String] = inputs.count > 1 ? Array(inputs[1..<inputs.count]) : []
    let noArguments = arguments.count != 1
    
    let validPattern = "x."
    let validPatternSet = CharacterSet(charactersIn: validPattern).inverted
    let invalidPattern = arguments.count > 0 ? (arguments[0].rangeOfCharacter(from: validPatternSet) != nil) : false
    
    switch command.lowercased() {
      
    case "kick" where noArguments,
         "hihat" where noArguments,
         "snare" where noArguments:
      throw Error.invalidArgument(reason: "\(command): Invalid arguments.\nUsage: \(command) <pattern>")
      
    case "kick" where invalidPattern,
         "hihat" where invalidPattern,
         "snare" where invalidPattern:
      throw Error.invalidArgument(reason: "\(command): Invalid pattern.\nUsage: Pattern must use \"x\" and \".\" characters only.")
      
    case "kick":
      self = Command.kick(pattern: arguments[0])
    case "hihat":
      self = Command.hihat(pattern: arguments[0])
    case "snare":
      self = Command.snare(pattern: arguments[0])
      
    case "play":
      self = Command.play
    case "preset":
      self = Command.preset
    case "quit":
      self = Command.quit
    default:
      throw Command.Error.invalidCommand(command: command)
    }
  }
}

extension Command {
  
  enum Error:Swift.Error {
    case invalidArgument(reason: String)
    case invalidCommand(command: String)
  }
}

extension Command.Error: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalidArgument (let reason):
      return reason
    case .invalidCommand(let command):
      return "Command not found: \(command.uppercased())."
    }
  }
}
