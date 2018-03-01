//
//  ViewController.swift
//  ModelRenderer
//
//  Created by Jigs Sheth on 3/1/18.
//  Copyright © 2018 sheth. All rights reserved.
//

import Cocoa
import SceneKit

class ViewController: NSViewController {
	@IBOutlet var sceneView: SceneView!

	
	//Map the object names from .dae to strings we want to show to the user
	let partNames = ["head" : "Head",
									 "eye_l" : "Left eye",
									 "eye_r" : "Right eye",
									 "neck" : "Neck",
									 "torso" : "Torso",
									 "arm_l" : "Left arm",
									 "arm_r" : "Right arm",
									 "hand_l" : "Left hand",
									 "hand_r" : "Right hand",
									 "leg_l" : "Left leg",
									 "leg_r" : "Right leg",
									 "foot_l" : "Left foot",
									 "foot_r" : "Right foot"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.sceneView.allowsCameraControl = true
		self.sceneView.isJitteringEnabled = true
		self.sceneView.backgroundColor = NSColor.black
		
		let url:NSURL = Bundle.main.url(forResource: "body", withExtension: "dae")! as NSURL
		self.sceneView.loadSceneAtURL(url: url)
		self.sceneView.selectionDelegate = self
		
		let NSURLPboardType = NSPasteboard.PasteboardType(kUTTypeURL as String)
		self.sceneView.registerForDraggedTypes([NSURLPboardType])
	}
	
}


extension ViewController:ItemSelectionDelegate{
	func onItemSelected(name: String) {
		print("name: " + name)
	}
	
	
}
