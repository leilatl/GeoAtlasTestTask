//
//  CountryListInteractor.swift
//  GeoAtlasTest
//
//  Created by Dmitry Serebrov on 13.05.2023.
//

import Foundation
/// протокол описывающий класс CountryListInteractor, им будет пользоваться View Controller для вызова данных
protocol ICountryListInteractor {
	func getCountries()
}

/// класс, ответственный за получение данных из сети
class CountryListInteractor: ICountryListInteractor {
	/// воркер для вызова запросов в сеть
	private var worker: ICountryListWorker
	/// презентер для дальнейшей передачи данных
	private var presenter: ICountryListPresenter
	
	/// функция, которая получает данные из сети, обрабатывает их для дальнейшей работы и отправляет в презентер
	func getCountries() {
		worker.fetchAllCountries { dataCountries in
			// создаем пустой массив данных
			var continentsData = CountryListModel.Data(continents: [:])
			
			// наполняем массив на каждую страну, которую получили из сети
			for dataCountry in dataCountries {
				
				// создаем новую модель страны
				let newCountry = self.transformNetworkDataToModelData(dataCountry: dataCountry)
				
				// определяем ее место в Dictionary континентов
				for continentKey in dataCountry.continents {
					if continentsData.continents[continentKey] != nil {
						// если континент это страны уже существует в Dictionary, то добавлем по существующему ключу
						continentsData.continents[continentKey]?.append(newCountry)
					} else {
						// если континент этой страны еще не был создан, то добавляем новый ключ и страну
						continentsData.continents[continentKey] = [newCountry]
					}
				}
			}
			// передаем данные дальше презентеру
			self.presenter.presentCountries(response: continentsData)
		}
	}
	
	init(worker: ICountryListWorker, presenter: ICountryListPresenter) {
		self.worker = worker
		self.presenter = presenter
	}
}
/// расширение для приватных функций
extension CountryListInteractor {
	/// функция, которая преобразует данные из Networking data в Data (данные внутренней логики)
	private func transformNetworkDataToModelData(dataCountry: CountryListModel.NetworkingData.CountryListData.Country) -> CountryListModel.Data.Country {
		CountryListModel.Data.Country(image: dataCountry.flags.png,
													   name: dataCountry.name.common,
													   capital: dataCountry.capital,
													   population: dataCountry.population,
													   area: dataCountry.area,
													   currencies: dataCountry.currencies,
													   cca2: dataCountry.cca2)
	}
}
