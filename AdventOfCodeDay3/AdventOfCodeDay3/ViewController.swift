//
//  ViewController.swift
//  AdventOfCodeDay3
//
//  Created by nayome.devapriya on 2017/06/22.
//  Copyright © 2017 nayome.devapriya. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let filePath = Bundle.main.path(forResource: "Input", ofType: "txt") {
            let arrayOfFileContents = readContentsOfFile(fromPath: filePath)
            findNumberOfListedTraingles(fromInputList: arrayOfFileContents)
            findNumberOfListedTrainglesByColumn(fromInputList: arrayOfFileContents)
        }
    }
    
    func findNumberOfListedTraingles(fromInputList: [String]) {
        
        var countOfVaildTriangles = 0
        for input in fromInputList {
            if input != "" {
                let filteresString = input.components(separatedBy: " ").filter { $0 != "" }
                let firstSide = Int(filteresString[0])
                let secondSide = Int(filteresString[1])
                let thirdSide = Int(filteresString[2])
                
                let isValid = isValidTriangle(side1: firstSide!, side2: secondSide!, side3: thirdSide!)
                if isValid  {
                    countOfVaildTriangles += 1
                }

            }
        }
        print("countOfVaildTriangles is \(countOfVaildTriangles)")
    }
    
    func isValidTriangle(side1: Int, side2: Int, side3: Int) -> Bool {
        if ((side1 + side2) <= side3) || ((side2 + side3) <= side1) || ((side3 + side1) <= side2){
            return false
        }
        return true
    }
    
    func findVaildTriangles(inList: [Int]) -> Int
    {
        var countOfVaildTriangles = 0
        for (offset,index) in stride(from: inList.startIndex, through: inList.endIndex, by: 3).enumerated()
        {
            if offset < (inList.count / 3) {
                let isValid = isValidTriangle(side1: inList[index], side2: inList[index + 1], side3: inList[index + 2])
                if isValid  {
                    countOfVaildTriangles += 1
                }
            }
        }
        return countOfVaildTriangles
    }

    
    func findNumberOfListedTrainglesByColumn(fromInputList: [String]) {
        var countOfVaildTriangles = 0
        var column1 = [Int]()
        var column2 = [Int]()
        var column3 = [Int]()
        
        for input in fromInputList {
            if input != "" {
                let filteresString = input.components(separatedBy: " ").filter { $0 != "" }
                column1.append(Int(filteresString[0])!)
                column2.append(Int(filteresString[1])!)
                column3.append(Int(filteresString[2])!)
            }
        }

        countOfVaildTriangles += findVaildTriangles(inList: column1)
        countOfVaildTriangles += findVaildTriangles(inList: column2)
        countOfVaildTriangles += findVaildTriangles(inList: column3)
        print("countOfVaildTriangles by column \(countOfVaildTriangles)")
    }

    
    //Function to read the contents of file, and returns an array of strings
    func readContentsOfFile(fromPath: String) -> [String] {
        do {
            let content = try String(contentsOfFile:fromPath, encoding: String.Encoding.utf8)
            if content == GlobalConstants.emptyString {
                return []
            }
            return content.components(separatedBy: GlobalConstants.newLineCharacter)
        } catch {
            return []
        }
    }


}

