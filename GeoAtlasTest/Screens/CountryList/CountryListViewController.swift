//
//  ViewController.swift
//  GeoAtlasTest
//
//  Created by Dmitry Serebrov on 13.05.2023.
//

import UIKit
import SnapKit

/// протокол описывающий класс CountryListViewController, им будет пользоваться Presenter для отображения подготовленных данных
protocol ICountryListViewController {
	func showCountries(viewModel: CountryListModel.ViewModel)
}

/// класс ответственный за внешний вид экрана CountryList, на котором отображается список стран
class CountryListViewController: UIViewController {
	
	/// вью модель, которая содержит всю необходимую информацию для отображния на экране
	var viewModel = CountryListModel.ViewModel(continents: [])
	/// основная таблица для отображения данных
	let tableView = UITableView()
	/// индекс выбраной ячейки. выбранная ячейка отличается внешним видом от остальных ячеек
	var selectedIndexPath: IndexPath? = nil
	/// интерактор для вызова запроса данных
	var interactor: ICountryListInteractor
	
	/// через инициализатор передаем интерактор
	init(interactor: ICountryListInteractor) {
		
		self.interactor = interactor
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder: NSCoder) {
		fatalError(UIStrings.initError)
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		style()
		layout()
		setupTableview()
		
		// вызываем у интерактора данные
		interactor.getCountries()
	}
}

/// расширение для протоколов, связаных с таблицей
extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {
	/// возвращает количество секций (континентов) в таблице, здесь таблица разделена на континенты.
	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.continents.count
	}
	
	/// возвращает название секции (континента). названия возвращаются заглавными буквами
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		viewModel.continents[section].name.uppercased()
	}
	
	/// возырвщвет количество стран в секции (континенте)
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return viewModel.continents[section].countries.count
	}
	
	/// возвращает ячейку для каждого ряда таблицы
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: UIStrings.cellId, for: indexPath) as! CountryCell
		
		// вызов функции для определения внешнего вида ячейки
		self.updateCell(ip: indexPath, cell: cell)
		
		return cell
	}
	
	/// возвращает высоту каждой ячейки. у нас все ячейки одной высоты, кроме выбранной ячейки. выбранная ячейка выше.
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		if indexPath == selectedIndexPath {
			return UIDigits.expandedCellHeight
		} else {
			return UIDigits.smallCellHeight
		}
	}
	
	/// функция, которая вызывается, когда мы нажали на ячейку в таблице
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// сохраняем старый индекс выбранной ячейки, чтобы в дальнейшем закрыть предыдущую выбранную ячейку
		let previousIndexPath = selectedIndexPath
		
		// назначаем новый индекс выбранной ячейки. если мы нажали на выбранную ячейку, то она должна закрыться, а новый индекс выбранной ячейки будет равен nil
		if selectedIndexPath == indexPath {
			selectedIndexPath = nil
		} else {
			selectedIndexPath = indexPath
		}
		
		// нужно обновить таблицу на месте новой выбранной ячейки (открыть ее)
		tableView.reloadRows(at: [indexPath], with: .automatic)
		
		// а также нужно обновить таблицу на месте старой выбранной ячейки если она есть (закрыть ее)
		if let previousIndexPath {
			tableView.reloadRows(at: [previousIndexPath], with: .automatic)
		}
	}
	
}

/// расширение для протокола ICountryListViewController, для пользования Presenter
extension CountryListViewController: ICountryListViewController {
	/// через эту функцию Presenter передает готовые для отображения данные в ViewController обновляет таблицу со свежими данными
	func showCountries(viewModel: CountryListModel.ViewModel) {
		self.viewModel = viewModel
		tableView.reloadData()
	}
	
}

/// расширение для приватных функций
extension CountryListViewController {
	/// функция, которая определяет, как будет выглядеть каждая ячейка
	private func updateCell(ip: IndexPath, cell: CountryCell) {
		// у нас есть 2 разных ситуации
		if ip == selectedIndexPath {
			// 1 ситуация - наша ячейка выбранная. передаем view controller для дальнейшей навигации
			cell.updateExpanded(viewModel: viewModel.continents[ip.section].countries[ip.row], vc: self)
		} else {
			// 2 ситуация - наша ячейка не выбранная(
			cell.updateCollapsed(viewModel: viewModel.continents[ip.section].countries[ip.row])
		}
	}
	
	/// функция для группировки операций с внешним видом UI элементов
	private func style() {
		navigationItem.title = UIStrings.navigationItemTitle
		view.backgroundColor = UIColors.greyBackground
		tableView.separatorStyle = .none
	}
	
	/// функция для группировки операций с разметкой UI элементов на экране
	private func layout() {
		view.addSubview(tableView)
		tableView.snp.makeConstraints { maker in
			maker.left.equalToSuperview()
			maker.right.equalToSuperview()
			maker.top.equalToSuperview()
			maker.bottom.equalToSuperview()
		}
	}
	
	/// функция для подготовки таблицы
	private func setupTableview() {
		tableView.dataSource = self
		tableView.delegate = self
		
		tableView.register(CountryCell.self, forCellReuseIdentifier: UIStrings.cellId)
	}
}
