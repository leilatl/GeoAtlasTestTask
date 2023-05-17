//
//  MainRouter.swift
//  GeoAtlasTest
//
//  Created by Dmitry Serebrov on 14.05.2023.
//

import Foundation
// класс, ответственный за навигацию между экранами
class MainRouter {
	func routeToDetailsViewController(vc: ICountryListViewController, cca2: String) {
		guard let rootViewController = vc as? CountryListViewController else { return }
		let worker = CountryDetailWorker()
		let presenter = CountryDetailPresenter()
		let interactor = CountryDetailInteractor(worker: worker, presenter: presenter)
		let vc = CountryDetailViewController(interactor: interactor)
		presenter.setViewController(viewController: vc)
		let destinationVC = vc
		destinationVC.countryCode = cca2
		navigateToDetailsViewController(source: rootViewController, destination: destinationVC)
	}

	private func navigateToDetailsViewController(source: CountryListViewController, destination: CountryDetailViewController) {
		source.show(destination, sender: nil)
	}
}
