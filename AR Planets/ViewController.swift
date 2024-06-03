//
//  ViewController.swift
//  AR Planets
//
//  Created by Arthur Nsereko Kahwa on 04/09/2018.
//  Copyright © 2018 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit
import ARKit

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}


class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.session.run(configuration)
    }

    override func viewDidAppear(_ animated: Bool) {

        let earth = planet(geometry: SCNSphere(radius: 0.2),
                           diffuse: #imageLiteral(resourceName: "Earth Day"),
                           emission: #imageLiteral(resourceName: "Earth Emission"),
                           normal: #imageLiteral(resourceName: "Earth Normal"),
                           specular: #imageLiteral(resourceName: "Earth Specular"),
                           position: SCNVector3(0.2, 0, 0))

        let action = SCNAction.rotateBy(x: CGFloat(3.degreesToRadians),
                                        y: CGFloat(350.degreesToRadians),
                                        z: CGFloat(6.degreesToRadians),
                                        duration: 8)
        let forever = SCNAction.repeatForever(action)
        earth.runAction(forever)

        let teapotScene = SCNScene(named: "art.scnassets/Chaynik.scn")
        let teapotNode = teapotScene?.rootNode.childNode(withName: "Chaynik", recursively: true)
        teapotNode?.position = SCNVector3(0, 0, -1.5)

        let teapotRotation = SCNAction.rotateBy(x: CGFloat(180.degreesToRadians),
                                                y: CGFloat(270.degreesToRadians),
                                                z: CGFloat(360.degreesToRadians),
                                                duration: 10)
        teapotNode?.runAction(SCNAction.repeatForever(teapotRotation))

        let teapotParent = SCNNode()
        teapotParent.position = earth.position
        let teapotParentRotation = SCNAction.rotateBy(x: CGFloat(360.degreesToRadians),
                                                      y: CGFloat(20.degreesToRadians),
                                                      z: CGFloat(30.degreesToRadians),
                                                      duration: 10)
        teapotParent.runAction(SCNAction.repeatForever(teapotParentRotation))
        teapotParent.addChildNode(teapotNode!)
        earth.addChildNode(teapotParent)

        let sun = planet(geometry: SCNSphere(radius: 0.35),
                                             diffuse: #imageLiteral(resourceName: "Sun Diffuse"),
                                             emission: nil,
                                             normal: nil,
                                             specular: nil,
                                             position: SCNVector3(0, 0.2, -1.3))

        let sunParent = SCNNode()
        let sunParentRotation = SCNAction.rotateBy(x: 0,
                                                   y: CGFloat(360.degreesToRadians),
                                                   z: 0,
                                                   duration: 16)
        sunParent.runAction(SCNAction.repeatForever(sunParentRotation))
        sunParent.addChildNode(sun)
        earth.addChildNode(sunParent)

        let venus = planet(geometry: SCNSphere(radius: 0.15),
                           diffuse: #imageLiteral(resourceName: "Venus Surface"),
                           emission: #imageLiteral(resourceName: "Venus Atmosphere"),
                           normal: nil,
                           specular: nil,
                           position: SCNVector3(0.6, 0, 0))
        let venusParent = SCNNode()
        // venusParent.position = sunParent.position
        let venusParentRotation = SCNAction.rotateBy(x: CGFloat(360.degreesToRadians),
                                                     y: 0,
                                                     z: CGFloat(60.degreesToRadians),
                                                     duration: 10)
        venusParent.runAction(SCNAction.repeatForever(venusParentRotation))
        venusParent.addChildNode(venus)

        let venusMoon = planet(geometry: SCNSphere(radius: 0.06),
                               diffuse: #imageLiteral(resourceName: "Moon Diffuse"),
                               emission: nil,
                               normal: nil,
                               specular: nil,
                               position: SCNVector3(0, 0.2, 0.2))

        let venusMoonParent = SCNNode()
        venusMoonParent.position = venus.position
        let venusMoonRotation = SCNAction.rotateBy(x: CGFloat(360.degreesToRadians),
                                                   y: 0,
                                                   z: 0,
                                                   duration: 0.7)
        venusMoonParent.runAction(SCNAction.repeatForever(venusMoonRotation))
        venusMoonParent.addChildNode(venusMoon)
        venusParent.addChildNode(venusMoonParent)
        sun.addChildNode(venusParent)

        self.sceneView.scene.rootNode.addChildNode(earth)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func planet(geometry: SCNGeometry,
                diffuse: UIImage?,
                emission: UIImage?,
                 normal: UIImage?,
                specular: UIImage?,
                position: SCNVector3) -> SCNNode {

        let planet = SCNNode(geometry: geometry)
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.emission.contents = emission
        planet.geometry?.firstMaterial?.normal.contents = normal
        planet.geometry?.firstMaterial?.specular.contents = specular
        planet.position = position

        return planet
    }


}

