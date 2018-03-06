//
//  MAGCustomGeometryModel.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 08.10.17.
//  Copyright © 2017 Хохлова Татьяна. All rights reserved.
//


import UIKit
import SceneKit


class MAGCustomGeometryModel: NSObject
{
    var elementsArray: [MAGHexahedron] = []
    var centerPoint: SCNVector3 = SCNVector3Zero
    var minVector: SCNVector3 = SCNVector3Zero
    var maxVector: SCNVector3 = SCNVector3Zero
    var xyzArray: [SCNVector3] = []
    var nverArray: [[Int]] = []
    var nvkatArray: [Int] = []
    var neibArray: [[Int]] = []
    
    override init()
    {
        super.init()
        
        createElementsArray()
    }
    
    func createElementsArray ()
    {
        xyzArray = MAGFileManager.sharedInstance.getXYZArray()
        nverArray = MAGFileManager.sharedInstance.getNVERArray()
        nvkatArray = MAGFileManager.sharedInstance.getNVKATArray()
        neibArray = MAGFileManager.sharedInstance.getNEIBArray()
        
        minVector = xyzArray.first!
        maxVector = xyzArray.last!
        
        let xyzCalc: Float = abs((maxVector.y - minVector.y) / 4.0)
        
        var arrayOfVectors: [SCNVector3]? = []
        for xyz in xyzArray
        {
            let vector = SCNVector3Make(Float(xyz.x / xyzCalc),
                                        Float(xyz.y / xyzCalc),
                                        Float(xyz.z / xyzCalc))
            arrayOfVectors?.append(vector)
        }
        xyzArray = arrayOfVectors!
        minVector = xyzArray.first!
        maxVector = xyzArray.last!
        
        var countArray = Array(repeating: 0, count: 100000)
        for nver in nverArray
        {
            var i : Int = 0
            for grid in nver
            {
                if i < 8
                {
                    countArray[grid - 1] += 1
                }
                else
                {
                    break
                }
                i = i + 1
            }
        }
        var j : Int = 0
        var numberOfElement : Int = 0
        for nverElementArray in nverArray
        {
            var sidesFlagsArray: [Bool] = [true, true, true, true, true, true]
            var nverCountArray : [Int] = []
            var positionArray : [SCNVector3]? = []
            var materialsArray: [Int] = []
            var i : Int = 0
            
            for gridNum in nverElementArray
            {
                if i < 8
                {
                    let vector = xyzArray[gridNum - 1]
                    positionArray?.append(vector)
                    nverCountArray.append(countArray[gridNum - 1])
                }
                else
                {
                    materialsArray.append(gridNum)
                }
                i = i + 1
            }
            j = j + 1
            
            
            for numberOfSide in 0..<6
            {
                sidesFlagsArray[numberOfSide] = (neibArray[6*numberOfElement + numberOfSide].count == 1)
            }
            
            let sidesArray: [MAGSide]? = [
                MAGSide.init(positions: [positionArray![0], positionArray![2], positionArray![6], positionArray![4]],
                             positionType: .Left,
                             material: materialsArray[0],
                             isVisible: sidesFlagsArray[0]), //левая
                MAGSide.init(positions: [positionArray![0], positionArray![1], positionArray![5], positionArray![4]],
                             positionType: .Front,
                             material: materialsArray[1],
                             isVisible: sidesFlagsArray[1]), //передняя
                MAGSide.init(positions: [positionArray![0], positionArray![1], positionArray![3], positionArray![2]],
                             positionType: .Bottom,
                             material: materialsArray[2],
                             isVisible: sidesFlagsArray[2]), //нижняя
                MAGSide.init(positions: [positionArray![1], positionArray![3], positionArray![7], positionArray![5]],
                             positionType: .Right,
                             material: materialsArray[3],
                             isVisible: sidesFlagsArray[3]), //правая
                MAGSide.init(positions: [positionArray![2], positionArray![3], positionArray![7], positionArray![6]],
                             positionType: .Back,
                             material: materialsArray[4],
                             isVisible: sidesFlagsArray[4]), //задняя
                MAGSide.init(positions: [positionArray![4], positionArray![5], positionArray![7], positionArray![6]],
                             positionType: .Top,
                             material: materialsArray[5],
                             isVisible: sidesFlagsArray[5]),  //верхняя
            ]
            
            
            elementsArray.append(MAGHexahedron.init(positions: positionArray!,
                                                    sidesArray: sidesArray!,
                                                    materialsArray: materialsArray,
                                                    counts: nverCountArray))
            //break
            numberOfElement = numberOfElement + 1
        }
        centerPoint = SCNVector3Make((maxVector.x - minVector.x) / 2.0 + minVector.x,
                                     (maxVector.y - minVector.y) / 2.0 + minVector.y,
                                     (maxVector.z - minVector.z) / 2.0 + minVector.z)
    }
}

