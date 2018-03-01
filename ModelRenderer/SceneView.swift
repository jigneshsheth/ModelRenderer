//
//  ASCView.swift
//  ModelRenderer
//
//  Created by Jigs Sheth on 3/1/18.
//  Copyright © 2018 sheth. All rights reserved.
//

import SceneKit
import QuartzCore

protocol ItemSelectionDelegate {
	func onItemSelected(name:String)
}

class SceneView: SCNView {
	
	var selectionDelegate:ItemSelectionDelegate!
	var selectedMaterial:SCNMaterial!
	
	func loadSceneAtURL(url:NSURL) {
		let options = [SCNSceneSource.LoadingOption.createNormalsIfAbsent : true]
		do {
			let maybeScene:SCNScene? =  try SCNScene(url: url as URL, options: options)
			if let scene = maybeScene {
				self.scene = scene
			}
		}catch(let error) {
				print("Error loading scene: " + error.localizedDescription)
		}
	}
	
	
	func selectNode(node:SCNNode, geometryIndex:Int) {
		
		if (self.selectedMaterial != nil) {
			self.selectedMaterial.removeAllAnimations()
			self.selectedMaterial = nil
		}
		
		let unsharedMaterial:SCNMaterial = node.geometry!.materials[geometryIndex].copy() as! SCNMaterial
		node.geometry?.replaceMaterial(at: geometryIndex, with: unsharedMaterial)
		
		self.selectedMaterial = unsharedMaterial
		
		let highlightAnimation:CABasicAnimation = CABasicAnimation(keyPath: "contents")
		highlightAnimation.toValue = NSColor.blue
		highlightAnimation.fromValue = NSColor.black
		
		highlightAnimation.repeatCount = MAXFLOAT
		highlightAnimation.isRemovedOnCompletion = false
		highlightAnimation.fillMode = kCAFillModeForwards
		highlightAnimation.duration = 0.5
		highlightAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		
		self.selectedMaterial.emission.intensity = 1.0
		self.selectedMaterial.emission.addAnimation(highlightAnimation, forKey: "highlight")
		
		self.selectionDelegate.onItemSelected(name: node.name!)
	}
	
	override public func mouseDown(with event: NSEvent) {
		// Convert the mouse location in screen coordinates to local coordinates, then perform a hit test with the local coordinates.
		let mouseLocation:NSPoint =  self.convert(event.locationInWindow, to: nil)
		let hits = self.hitTest(mouseLocation, options: nil)
		
		// If there was a hit, select the nearest object; otherwise unselect.
		if hits.count > 0 {
			let hit:SCNHitTestResult = hits[0]
			self.selectNode(node: hit.node, geometryIndex: hit.geometryIndex)
		}
		super.mouseDown(with: event)
	}
	
}



// MARK: - Drag and drop
extension SceneView {
	
	func dragOperationForPasteboard(pasteboard:NSPasteboard) -> NSDragOperation {
		if (pasteboard.types?.contains(.fileURL))! {
			if let fileURL = NSURL(from: pasteboard), (fileURL.pathExtension) == "dae" {
				return NSDragOperation.copy
			}
		}
		return NSDragOperation()
	}
	
	func draggingUpdated(sender:NSDraggingInfo) -> NSDragOperation {
		return	self.dragOperationForPasteboard(pasteboard: sender.draggingPasteboard())
	}
	
	override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
		let pasteboard:NSPasteboard = draggingInfo.draggingPasteboard()
		if let _ = pasteboard.types?.contains(.fileURL){
			let fileURL = NSURL(from: pasteboard)
			self.loadSceneAtURL(url: fileURL!)
			return true
		}
		return false
	}
	
	override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
		return	self.dragOperationForPasteboard(pasteboard: sender.draggingPasteboard())
	}
	
	
	override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
		return	self.dragOperationForPasteboard(pasteboard: sender.draggingPasteboard())
	}
	
	override func draggingExited(_ sender: NSDraggingInfo?) {
	}
}
