//
//  ExperienceController.swift
//  Experiences
//
//  Created by Michael Redig on 10/4/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation
import CoreData

enum ExperienceType: String {
	case photo
	case video
	case audio
}

protocol ExperienceControllerAccessor: AnyObject {
	var experienceController: ExperienceController? { get set }
}

class ExperienceController {

	/// only access from main thread
	private(set) var experiences: [Experience] = []

	init() {
		updateExperiences()
	}
	
	func createExperience(titled title: String, tempMediaURL: URL, type: ExperienceType, latitude: Double, longitude: Double) {
		guard let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
		let name = tempMediaURL.lastPathComponent
		let destination = documentsFolder.appendingPathComponent(type.rawValue).appendingPathComponent(name)

		do {
			try FileManager.default.moveItem(at: tempMediaURL, to: destination)
		} catch {
			NSLog("Error moving file to permanent storage: \(error)")
		}

		let context = CoreDataStack.shared.mainContext
		context.perform {
			Experience(title: title, mediaURL: destination, longitude: longitude, latitude: latitude, context: context)
		}
		updateExperiences()
	}

	private func updateExperiences() {
		let moc = CoreDataStack.shared.mainContext
		moc.perform {
			do {
				let fetchRequest: NSFetchRequest<Experience> = Experience.fetchRequest()
				let experiences = try moc.fetch(fetchRequest)
				self.experiences = experiences
			} catch {
				NSLog("Error fetching experiences: \(error)")
			}
		}
	}
}
