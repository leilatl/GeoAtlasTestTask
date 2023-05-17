//
//  CountryListPresenter.swift
//  GeoAtlasTest
//
//  Created by Dmitry Serebrov on 13.05.2023.
//

import Foundation
import UIKit
/// протокол описывающий класс CountryListPresenter, им будет пользоваться Interactor для передачи данных
protocol ICountryListPresenter {
	func presentCountries(response: CountryListModel.Data)
}

/// класс, ответственный за подготовку данных к отображению на экране
class CountryListPresenter: ICountryListPresenter {
	/// вью контроллер, который должен отобразить данные
	weak var viewController: CountryListViewController?
	
	/// функция для определения вью контроллера
	func setViewController(viewController: CountryListViewController) {
		self.viewController = viewController
	}
	
	/// функция, которая готовит данные для отображения на экране и передает их в вью контроллер
	func presentCountries(response: CountryListModel.Data) {
		// создаем пустой массив данных
		var continentsViewModel = CountryListModel.ViewModel(continents: [])
		
		// проходимся по каждому континенту и добавляем его в массив
		for continent in response.continents {
			// для каждого континента создаем пустой массив стран
			var newContinentViewModel = CountryListModel.ViewModel.ContinentViewModel(name: continent.key, countries: [])
			
			for country in continent.value {
				// для каждой страны в континенте создаем новую модель и добавляем в массив стран
				let newCountryViewModel = CountryListModel.ViewModel.CountryViewModel(flag: country.image,
																					  name: country.name,
																					  capital: country.capital?[0] ?? UIStrings.unknownCapital,
																					  population: self.transformPopulation(dataPopulation: country.population),
																					  area: self.transformArea(dataArea: country.area),
																					  currencies: self.transformCurrencies(dataCurrency: country.currencies),
																					  cca2: country.cca2)
				
				newContinentViewModel.countries.append(newCountryViewModel)
			}
			// добавляем новый континент в массив континентов
			continentsViewModel.continents.append(newContinentViewModel)
		}
		
		// передаем данные в вью контроллер и вызываем фнукцию отображения данных
		viewController?.showCountries(viewModel: continentsViewModel)
	}
	
}
/// расширение для приватных функций
extension CountryListPresenter {
	/// функция, которая преобразует валюты из модели в строку для оторажения на экране
	private func transformCurrencies(dataCurrency: [String: CountryListModel.NetworkingData.CurrencyValue]?) -> String {
		var currencyString = ""
		// проверка наличия модели
		if let dataCurrency {
			// если в массиве только 1 валюта, то мы отображем название, символ и код
			if dataCurrency.count == 1 {
				currencyString = "\(dataCurrency.first?.value.name ?? "") (\(dataCurrency.first?.value.symbol ?? "")) (\(dataCurrency.first?.key ?? ""))"
				// если в массиве 2 или больше валют, то мы перечисляем их через запятую
			} else if dataCurrency.count > 1 {
				for data in dataCurrency {
					currencyString += "\(data.value.name), "
				}
				currencyString = String(currencyString.dropLast(2))
			}
		}
		return currencyString
	}
	/// функция, которая преобразует население из модели в строку для оторажения на экране
	private func transformPopulation(dataPopulation: Int) -> NSMutableAttributedString {
		var populationStr = String(dataPopulation)
		
		// если население страны больше миллиона, то мы отображаем только количество миллионов
		if dataPopulation >= 1000000 {
			populationStr = "\(Int(dataPopulation/1000000)) mln"
			// если население страны меньше миллиона, но больше тысячи, то мы отображаем население в формате: 100 000
		} else if dataPopulation < 1000000 && dataPopulation > 1000 {
			
			populationStr.insert(contentsOf: " ", at: populationStr.index(populationStr.endIndex, offsetBy: -3))
			// если население страны меньше тысячи, но больше тысячи, то мы не меняем строку
		} else {
			populationStr = "\(dataPopulation)"
		}
		var attrStrPopulation = NSMutableAttributedString(string: populationStr)
		attrStrPopulation = NSMutableAttributedString(string: "Population: \(populationStr)")
		attrStrPopulation.addAttribute(.foregroundColor, value: UIColors.greyText ?? UIColor.gray, range: NSRange(location: 0, length: 11))
		
		return attrStrPopulation
	}
	
	/// функция, которая преобразует площадь из модели в строку для оторажения на экране
	private func transformArea(dataArea: Float) -> NSMutableAttributedString {
		let intArea = Int(dataArea)
		var stringArea = String(intArea)
		
		// если площадь страны меньше миллиона, но больше тысячи, то мы отображаем площадь в формате: 100 000
		if intArea < 1000000 && intArea > 1000 {
			stringArea.insert(contentsOf: " ", at: stringArea.index(stringArea.endIndex, offsetBy: -3))
			// если площадь страны больше миллиона, то мы отображаем только количество миллионов
		} else if intArea > 1000000 {
			stringArea = String(stringArea.dropLast(3))
			stringArea.insert(contentsOf: ".", at: stringArea.index(stringArea.endIndex, offsetBy: -3))
			stringArea += " mln"
		}
		var attrStrArrea = NSMutableAttributedString(string: stringArea)
		attrStrArrea = NSMutableAttributedString(string: "Area: \(stringArea) km²")
		attrStrArrea.addAttribute(.foregroundColor, value: UIColors.greyText ?? UIColor.gray, range: NSRange(location: 0, length: 5))
		
		return attrStrArrea
	}
}
