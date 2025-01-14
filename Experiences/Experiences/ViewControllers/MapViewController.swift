//
//  MapViewController.swift
//  Experiences
//
//  Created by Michael Redig on 10/4/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, ExperienceControllerAccessor {
	@IBOutlet var newExperienceButton: UIButton!
	@IBOutlet var mapView: MKMapView!

	var experienceController: ExperienceController?

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		newExperienceButton.layer.cornerRadius = 10

	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		showExperiences()
	}

	private func showExperiences() {
		guard let experienceController = experienceController else { return }
		mapView.removeAnnotations(mapView.annotations)

		mapView.addAnnotations(experienceController.experiences)
	}

	@IBAction func catalogNewExperienceButtonPressed(_ sender: UIButton) {
		showExperienceSelectionPrompt()
	}

	private func showExperienceSelectionPrompt() {
		let alertVC = UIAlertController(title: "Capture", message: "What would be the best way to capture this experience?", preferredStyle: .alert)

		if experienceController?.locationManager.isAuthorized == true {
			let photoAction = UIAlertAction(title: "Photograph", style: .default) { _ in
				self.showVCIdentifiedBy("PhotographViewController")
			}
			let audioAction = UIAlertAction(title: "Audio", style: .default) { _ in
				self.showVCIdentifiedBy("AudioViewController")
			}
			let videoAction = UIAlertAction(title: "Video", style: .default) { _ in
				self.showVCIdentifiedBy("VideoViewController")
			}
			alertVC.addAction(audioAction)
			alertVC.addAction(photoAction)
			alertVC.addAction(videoAction)
		} else {
			alertVC.message = "Location services need to be enabled to do anything practical with this app. If you denied access, go to your device settings and rethink what you've done."
			alertVC.addAction(UIAlertAction(title: "Fiiiiiiine", style: .cancel))
		}

		if experienceController?.locationManager.lastLocation == nil {
			experienceController?.locationManager.singleLocationRequest()
		}

		present(alertVC, animated: true)
	}

	private func showVCIdentifiedBy(_ identifer: String) {
		guard let vc = storyboard?.instantiateViewController(withIdentifier: identifer) else { return }
		navigationController?.pushViewController(vc, animated: true)
	}
}

