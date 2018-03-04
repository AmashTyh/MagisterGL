//
//  MAGFileManager.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 08.10.17.
//  Copyright © 2017 Хохлова Татьяна. All rights reserved.
//


import UIKit
import SceneKit


class MAGFileManager: NSObject
{
    public var testType: Int = 0
    static let sharedInstance = MAGFileManager()
    
    
    func getXYZArray(path: String) -> Array<SCNVector3>
    {
        do
        {
            let fileExtension = URL.init(fileURLWithPath: path).pathExtension
            if  fileExtension == "dat"
            {
                let scaner = try MAGBinaryDataScanner.init(data: NSData.init(contentsOfFile: path),
                                                           littleEndian: true,
                                                           encoding: String.Encoding.ascii)
                var arrayOfVectors: [SCNVector3]? = []
                var array: [Float64]? = []
                while let value = scaner.readDouble()
                {
                    array?.append(value)
                    if array?.count == 3
                    {
                        let vector = SCNVector3Make(Float(array![0]),
                                                    Float(array![1]),
                                                    Float(array![2]))
                        arrayOfVectors?.append(vector)
                        array = []
                    }
                }
                return arrayOfVectors!
            }
            else
            {
                let data = try String(contentsOfFile: path,
                                      encoding: String.Encoding.ascii)
                var arrayOfVectors: [SCNVector3]? = []
                for string in data.components(separatedBy: "\n")
                {
                    if string != ""
                    {
                        let array = string.components(separatedBy: " ").map { Float($0)! }
                        if array.count == 3
                        {
                            let vector = SCNVector3Make(array[0],
                                                        array[1],
                                                        array[2])
                            arrayOfVectors?.append(vector)
                        }
                    }
                }
                return arrayOfVectors!
                
            }
        }
        catch let err as NSError
        {
            // do something with Error
            print(err)
        }
        return []
    }
    
    
    func getXYZArray() -> Array<SCNVector3>
    {
        var path: String
        switch testType
        {
        case 0:
            path = Bundle.main.path(forResource: "xyz",
                                    ofType: "txt")!
            break;
        case 1:
            path = Bundle.main.path(forResource: "xyz2",
                                    ofType: "txt")!
            break;
        case 2:
            path = Bundle.main.path(forResource: "xyz",
                                    ofType: "dat")!
            break;
        default:
            path = Bundle.main.path(forResource: "xyz",
                                    ofType: "txt")!
            break;
        }
        return self.getXYZArray(path: path)
    }
    
    
    func getNVERArray() -> [[Int]]
    {
        var path: String
        switch testType
        {
        case 0:
            path = Bundle.main.path(forResource: "nver",
                                    ofType: "txt")!
            break;
        case 1:
            path = Bundle.main.path(forResource: "nver2",
                                    ofType: "txt")!
            break;
        case 2:
            path = Bundle.main.path(forResource: "nver",
                                    ofType: "dat")!
            break;
        default:
            path = Bundle.main.path(forResource: "nver",
                                    ofType: "txt")!
            break;
        }
        return self.getNVERArray(path: path)
    }
    
    
    func getNVERArray(path: String) -> [[Int]]
    {
        do
        {
            let fileExtension = URL.init(fileURLWithPath: path).pathExtension
            if  fileExtension == "dat"
            {
                let scaner = try MAGBinaryDataScanner.init(data: NSData.init(contentsOfFile: path),
                                                           littleEndian: true,
                                                           encoding: String.Encoding.ascii)
                var arrayOfVectors: [[Int]]? = []
                var array: [Int]? = []
                while let value = scaner.read32()
                {
                    array?.append(Int(value))
                    if array?.count == 14
                    {
                        arrayOfVectors?.append(array!)
                        array = []
                    }
                }
                return arrayOfVectors!
            }
            else
            {
                let data = try String(contentsOfFile: path,
                                      encoding: String.Encoding.ascii)
                var arrayOfVectors: [[Int]]? = []
                for string in data.components(separatedBy: "\n")
                {
                    if string != ""
                    {
                        let array = string.components(separatedBy: " ").map { Int($0)!}
                        arrayOfVectors?.append(array)
                    }
                }
                return arrayOfVectors!
            }
        }
        catch let err as NSError
        {
            // do something with Error
            print(err)
        }
        return []
    }
    
    func getNVKATArray() -> Array<Int>
    {
        var path: String
        switch testType
        {
        case 0:
            path = Bundle.main.path(forResource: "nvkat",
                                    ofType: "txt")!
            break;
        case 1:
            path = Bundle.main.path(forResource: "nvkat2",
                                    ofType: "txt")!
            break;
        case 2:
            path = Bundle.main.path(forResource: "nvkat",
                                    ofType: "dat")!
            break;
        default:
            path = Bundle.main.path(forResource: "nvkat",
                                    ofType: "txt")!
            break;
        }
        return self.getNVKATArray(path: path)
    }
    
    func getNVKATArray(path: String) -> Array<Int>
    {
        do
        {
            let fileExtension = URL.init(fileURLWithPath: path).pathExtension
            if  fileExtension == "dat"
            {
                let scaner = try MAGBinaryDataScanner.init(data: NSData.init(contentsOfFile: path),
                                                           littleEndian: true,
                                                           encoding: String.Encoding.ascii)
                var array: [Int]? = []
                while let value = scaner.read32()
                {
                    array?.append(Int(value))
                }
                return array!
            }
            else
            {
                let data = try String(contentsOfFile: path,
                                      encoding: String.Encoding.ascii)
                var array: [Int]? = []
                for string in data.components(separatedBy: "\n")
                {
                    if string != ""
                    {
                        let tempArray = string.components(separatedBy: "\r");
                        let value = Int(tempArray[0].trimmingCharacters(in: .whitespaces))!
                        array?.append(Int(value))
                    }
                }
                return array!
            }
        }
        catch let err as NSError
        {
            // do something with Error
            print(err)
        }
        return []
    }
}
