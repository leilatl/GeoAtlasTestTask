//
//  CountryDetailInteractor.swift
//  GeoAtlasTest
//
//  Created by Dmitry Serebrov on 14.05.2023.
//

import Foundation
/// протокол описывающий класс CountryDetailInteractor, им будет пользоваться View Controller для вызова данных
protocol ICountryDetailInteractor {
	func getCountryDetails(cca2: String)
}
/// класс, ответственный за получение данных из сети
class CountryDetailInteractor: ICountryDetailInteractor {
	/// воркер для вызова запросов в сеть
	private var worker: ICountryDetailWorker
	/// презентер для дальнейшей передачи данных
	private var presenter: ICountryDetailPresenter
	
	/// функция, которая получает данные из сети, обрабатывает их для дальнейшей работы и отправляет в презентер
	func getCountryDetails(cca2: String) {
		worker.fetchCountryDetails(cca2: cca2) { data in
			let newData = CountryDetailModel.Data(image: data[0].flags.png,
												  name: data[0].name.common,
												  capital: data[0].capital,
												  coordinates: data[0].capitalInfo?.latlng ?? [0],
												  population: data[0].population,
												  area: data[0].area,
												  currencies: self.transformCurrenciesToString(currencies: data[0].currencies),
												  timezones: data[0].timezones,
												  region: data[0].subregion ?? UIStrings.unknownRegion)
			self.presenter.presentDetails(response: newData)
		}
	}
	
	init(worker: ICountryDetailWorker, presenter: ICountryDetailPresenter) {
		self.worker = worker
		self.presenter = presenter
	}
}
/// расширение для приватных функций
extension CountryDetailInteractor {
	/// функция для приведения валют в массив строк для дальнейшей работы
	private func transformCurrenciesToString(currencies: [String: CountryDetailModel.NetworkingData.CurrencyValue]?) -> [String] {
		var currenciesString = [String]()
		if let currencies {
			for currency in currencies {
				currenciesString.append("\(currency.value.name) (\(currency.value.symbol ?? "")) (\(currency.key))")
			}
		}
		return currenciesString
	}
}
