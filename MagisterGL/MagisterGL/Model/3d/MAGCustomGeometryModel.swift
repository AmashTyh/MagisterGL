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
    var xyzArray: Array<SCNVector3> = []
    var nverArray:  [[Int]] = []
    var nvkatArray: [Int] = []
    
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
        var materialsArray: [Int] = []
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
                    materialsArray.append(grid)
                }
                i = i + 1
            }
        }
        var j : Int = 0
        for nverElementArray in nverArray
        {
            var nverCountArray : [Int] = []
            var positionArray : [SCNVector3]? = []
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
                    break
                }
                i = i + 1
            }
            j = j + 1
            elementsArray.append(MAGHexahedron.init(positions: positionArray!,
                                                    counts: nverCountArray,
                                                    materialsArray: materialsArray))
        }
        centerPoint = SCNVector3Make((maxVector.x - minVector.x) / 2.0 + minVector.x,
                                     (maxVector.y - minVector.y) / 2.0 + minVector.y,
                                     (maxVector.z - minVector.z) / 2.0 + minVector.z)
    }
}
