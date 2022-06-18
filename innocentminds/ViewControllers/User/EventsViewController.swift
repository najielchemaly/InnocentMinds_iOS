//
//  CalendarViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 2/9/19.
//  Copyright © 2019 infosys. All rights reserved.
//

import UIKit

class EventsViewController: BaseViewController {

    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelWeek: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var labelNoData: UILabel!
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    var events: [Event] = [Event]()
    var filteredEvents: [Event] = [Event]()
    var week: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupTableView()
        
        calendarType == CalendarType.Event.rawValue ? self.fetchEventsData() : self.fetchFoodData()
    }
    
    func initializeViews() {
        self.labelTitle.text = calendarType == CalendarType.Event.rawValue ? Localization.string(key: MessageKey.Event) : Localization.string(key: MessageKey.Food)

        self.labelMonth.text = Date().getMonthName().capitalizingFirstLetter()
        self.week = Date().getWeekNumber()
        self.labelWeek.text = "Week \(week)"
        
        self.labelNoData.text = calendarType == CalendarType.Event.rawValue ? Localization.string(key: MessageKey.NoEvents) : Localization.string(key: MessageKey.NoFood)
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.EventsTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.EventsTableViewCell)
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 110;
        
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }
        
        self.refreshControl.addTarget(self, action: #selector(refreshEventsData), for: UIControl.Event.valueChanged)
    }
    
    @objc func refreshEventsData() {
        calendarType == CalendarType.Event.rawValue ? self.fetchEventsData(showLoader: false) : self.fetchFoodData(showLoader: false)
    }
    
    func fetchEventsData(showLoader: Bool = true) {
        let userId = Objects.user.id ?? "0"
        
        if showLoader {
            self.showLoader()
        }
        
        DispatchQueue.global(qos: .background).async {
            let result = appDelegate.services.getEvents(userId: userId)
            DispatchQueue.main.async {
                if result?.status == ResponseStatus.SUCCESS.rawValue {
                    if let jsonObject = result?.json?.first, let jsonArray = jsonObject["events"] as? [NSDictionary] {
                        self.events = [Event]()
                        for json in jsonArray {
                            guard let event = Event.init(dictionary: json) else {
                                return
                            }
                            
                            self.events.append(event)
                        }
                        
                        self.filteredEvents = self.events
                    }
                    
                    self.filterData()
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    
                } else if let message = result?.message, !message.isEmpty {
                    self.showAlertView(message: message, isError: true)
                } else {
                    self.showAlertView(message: Localization.string(key: MessageKey.InternalServerError), isError: true)
                }
                
                self.hideLoader()
            }
        }
    }
    
    func fetchFoodData(showLoader: Bool = true) {
        let userId = Objects.user.id ?? "0"
        
        if showLoader {
            self.showLoader()
        }
        
        DispatchQueue.global(qos: .background).async {
            let result = appDelegate.services.getFoodCalendar(userId: userId)
            DispatchQueue.main.async {
                if result?.status == ResponseStatus.SUCCESS.rawValue {
                    if let jsonObject = result?.json?.first, let jsonArray = jsonObject["food_calendar"] as? [NSDictionary] {
                        self.events = [Event]()
                        for json in jsonArray {
                            guard let event = Event.init(dictionary: json) else {
                                return
                            }
                            
                            self.events.append(event)
                        }
                        
                        self.filteredEvents = self.events
                    }
                    
                    self.filterData()
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    
                } else if let message = result?.message, !message.isEmpty {
                    self.showAlertView(message: message, isError: true)
                } else {
                    self.showAlertView(message: Localization.string(key: MessageKey.InternalServerError), isError: true)
                }
                
                self.hideLoader()
            }
        }
    }

    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    @IBAction func buttonPreviousTapped(_ sender: Any) {
        if week > 1 {
            self.week = week - 1
        }
        
        self.labelWeek.text = "Week \(week)"
        
        self.buttonNext.isEnabled(enable: true)
        if week == 1 {
            self.buttonPrevious.isEnabled(enable: false)
        }
        
        self.filterData()
    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        let today = Date()
        let weekNumber = self.getNumberOfWeeksInMonth(today)
        if week < weekNumber {
            self.week = week + 1
        }
        
        self.labelWeek.text = "Week \(week)"
        
        self.buttonPrevious.isEnabled(enable: true)
        if week == weekNumber {
            self.buttonNext.isEnabled(enable: false)
        }
        
        self.filterData()
    }
    
    func filterData() {
        self.filteredEvents = self.events
        self.filteredEvents = self.filteredEvents.filter {
            let dateFormmatter = DateFormatter()
            dateFormmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if let strDate = $0.date,
                let date = dateFormmatter.date(from: "\(strDate) 12:00:00") {
                let filteredWeekNumber = self.getWeekNumberOfMonth(date)
                
                return filteredWeekNumber == self.week
            }
            
            return true
        }
        
        self.tableView.reloadData()

        self.labelNoData.isHidden = self.filteredEvents.count > 0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        if calendarType == CalendarType.Event.rawValue {
//            if let eventsDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.EventsDetailsViewController) as? EventsDetailsViewController {
//                let event = self.filteredEvents[indexPath.row]
//                eventsDetailsVC.selectedEvent = event
//                eventsDetailsVC.viewTitle = self.labelTitle.text
//                self.navigationController?.pushViewController(eventsDetailsVC, animated: true)
//            }
//        }
    }
}

extension EventsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filteredEvents.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calendarType == CalendarType.Event.rawValue ? 120 : 100
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        footerView.backgroundColor = .clear
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.EventsTableViewCell) as? EventsTableViewCell {
            
            let event = self.filteredEvents[indexPath.section]
            
            cell.labelTitle.text = event.title
            cell.labelTime.text = event.time
            cell.labelDate.text = event.date
            cell.labelDescription.text = event.description
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(didSelectRow))
            cell.addGestureRecognizer(tap)
            cell.tag = indexPath.section
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func didSelectRow(sender: UITapGestureRecognizer) {
        if let cell = sender.view as? EventsTableViewCell {
            if calendarType == CalendarType.Event.rawValue {
                if let eventsDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.EventsDetailsViewController) as? EventsDetailsViewController {
                    let event = self.filteredEvents[cell.tag]
                    eventsDetailsVC.selectedEvent = event
                    eventsDetailsVC.viewTitle = self.labelTitle.text
                    self.navigationController?.pushViewController(eventsDetailsVC, animated: true)
                }
            }
        }
    }
}
