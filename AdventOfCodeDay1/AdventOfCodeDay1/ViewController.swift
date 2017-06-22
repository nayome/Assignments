//
//  ViewController.swift
//  AdventCode1
//
//  Created by nayome.devapriya on 2017/06/16.
//  Copyright © 2017 nayome.devapriya. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var part1ResultTextField: NSTextField?
    @IBOutlet weak var part2ResultTextField: NSTextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let filePath = Bundle.main.path(forResource: "Input", ofType: "txt") {
            let arrayOfFileContents = readContentsOfFile(fromPath: filePath)
            
            let distance = calculateDistance(fromInputList: arrayOfFileContents)
            print("Distance from landing point to the headquarters is \(distance) blocks")
            part1ResultTextField?.stringValue = String(distance)
            
            let revisitedDistance = findRevisitedPath(fromInputList: arrayOfFileContents)
            print("Distance revisited is \(revisitedDistance)")
            part2ResultTextField?.stringValue = String(revisitedDistance)
            
        }
    }
    
    //MARK: Methods to read the input from file
    func readContentsOfFile(fromPath: String) -> [String] {
        do {
            let content = try String(contentsOfFile: fromPath)
            if content == Constants.emptyString {
                return []
            }
            return content.components(separatedBy: Constants.inputDelimiter)
        } catch {
            return []
        }
    }
    
    //MARK: Evaluation Methods for Part 1 and Part 2
    func calculateDistance(fromInputList: [String]) -> Int {
        var directionFacing = directions.north.rawValue
        var point: CGPoint = CGPoint()
        
        for instruction in fromInputList {
            let commandReceived = parse(theInstruction: instruction)
            
            directionFacing = findDirectionFacedAfterExecuting(commandToMove: commandReceived.commandToMove, currentDirection: directionFacing)
            
            let calculatedValue = distanceTravelled(directionFacing: directionFacing, numberOfBlocksToMove: CGFloat(commandReceived.numberOfBlocksToMove), previousPoint: point)
            point.x = calculatedValue.x
            point.y = calculatedValue.y
        }
        return Int(abs(point.x) + abs(point.y))
    }
    
    func findRevisitedPath(fromInputList: [String]) -> Int {
        var directionFacing = directions.north.rawValue
        var point: CGPoint = CGPoint()
        var visited: Set = Set<String>()
        
        outer: for instruction in fromInputList {
            let commandReceived = parse(theInstruction: instruction)
            
            directionFacing = findDirectionFacedAfterExecuting(commandToMove: commandReceived.commandToMove, currentDirection: directionFacing)
            
            for _ in 0..<Int(commandReceived.numberOfBlocksToMove) {
                let calculatedLocation  = distanceTravelled(directionFacing: directionFacing, numberOfBlocksToMove: 1, previousPoint: point)
                let newLocation = String(describing: calculatedLocation.x) + Constants.stringSeparator + String(describing: calculatedLocation.y)
                point = calculatedLocation
                if !visited.contains(newLocation) {
                    visited.insert(newLocation)
                } else { break outer}
            }
        }
        return Int(abs(point.x) + abs(point.y))
    }
    
    //MARK: Evaluation methods for solving the puzzles
    func findDirectionFacedAfterExecuting(commandToMove: Character, currentDirection: Int) -> Int {
        var directionFromInstruction = currentDirection
        if commandToMove == Character(Constants.instructionTakeLeft){
            directionFromInstruction -= 1;
            if directionFromInstruction < 0 {
                directionFromInstruction = directions.west.rawValue
            }
        } else { directionFromInstruction = (directionFromInstruction + 1) % Constants.totalCardinalDirections }
        return directionFromInstruction
    }
    
    func distanceTravelled(directionFacing: Int,numberOfBlocksToMove: CGFloat, previousPoint: CGPoint ) -> CGPoint {
        var calculatedPoint = previousPoint
        switch directionFacing {
        case directions.north.rawValue:
            calculatedPoint.y = calculatedPoint.y + numberOfBlocksToMove
        case directions.east.rawValue:
            calculatedPoint.x = calculatedPoint.x + numberOfBlocksToMove
        case directions.south.rawValue:
            calculatedPoint.y = calculatedPoint.y - numberOfBlocksToMove
        case directions.west.rawValue:
            calculatedPoint.x = calculatedPoint.x - numberOfBlocksToMove
        default: break
        }
        return calculatedPoint
    }
    
    func parse(theInstruction: String) -> (commandToMove: Character, numberOfBlocksToMove: Int) {
        let commandToMove: Character = theInstruction[theInstruction.startIndex]
        guard let numberOfBlocksToMove = Int(theInstruction.substring(from: theInstruction.index(after: theInstruction.startIndex))) else {
            print("Error: Failed to convert the string to integer")
            return (commandToMove, 0)
        }
        return (commandToMove, numberOfBlocksToMove)
    }
    
}

