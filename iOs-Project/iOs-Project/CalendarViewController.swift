//
//  CalendarViewController.swift
//  iOs-Project
//
//  Created by Jean Miquel on 23/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var calendarView: CalendarView!
    
    // MARK: - Constants
    
    // We cache our colors because we do not want to be creating
    // a new color every time a cell is displayed. We do not want a laggy
    // scrolling calendar.
    let white = UIColor(colorWithHexValue: 0xECEAED)
    let darkPurple = UIColor(colorWithHexValue: 0x3A284C)
    let dimPurple = UIColor(colorWithHexValue: 0x574865)
    
    
    // MARK: - View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        
        // Registering your cell is manditory
        calendarView.registerCellViewXib(file: "CalendarCellView")
        calendarView.scrollToDate(DateManager.currentDate())
        //Add gesture to the calendar
        let doubleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapCollectionView(gesture:)))
        doubleTapGesture.numberOfTapsRequired = 2  // add double tap
        calendarView.addGestureRecognizer(doubleTapGesture)
        calendarView.allowsMultipleSelection  = true    //range selection
        calendarView.rangeSelectionWillBeUsed = true
        
        //Cell inset
        calendarView.cellInset = CGPoint(x: 0, y: 0)       // default is (3,3)
        
        //Add the header
        calendarView.registerHeaderView(xibFileNames: ["CalendarHeader"])
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Gesture protocol
    
    /// Handle the double tap gesture
    ///
    /// - Parameter gesture: the related gesture
    func didDoubleTapCollectionView(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: gesture.view!)
        let cellState = calendarView.cellStatus(at: point)
        print(cellState!.date)
    }
    
    
    // MARK: - Calendar protocol
    
    /// To configure the calendar
    ///
    /// - Parameter calendar: calendar selected
    /// - Returns: parameter for configuration
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = DateManager.currentDate() // You can use date generated from a formatter
        let endDate = startDate.addingTimeInterval(31104000)                         // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid,
            firstDayOfWeek: .monday)
        return parameters
    }
    
    /// Set the settings of the calendar
    ///
    /// - Parameters:
    ///   - calendar: the calendar type
    ///   - cell: the calendar's cell
    ///   - date: corresponding date
    ///   - cellState: state of each cell
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let myCustomCell = cell as! CalendarCellView
        // Setup Cell text
        myCustomCell.dayLabel.text = cellState.text
        
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
    }
    
    
    /// Handle the date selection
    ///
    /// - Parameters:
    ///   - calendar: the calendar type
    ///   - date: the calendar's cell
    ///   - cell: corresponding date
    ///   - cellState: state of each cell
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    /// Handle the date deselection
    ///
    /// - Parameters:
    ///   - calendar: the calendar type
    ///   - date: the calendar's cell
    ///   - cell: corresponding date
    ///   - cellState: state of each cell
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    /// Handle the text color of the cell
    ///
    /// - Parameters:
    ///   - view: calendar view
    ///   - cellState: state of the cell calendar
    func handleCellTextColor(view: JTAppleDayCellView?, cellState: CellState) {
        
        guard let myCustomCell = view as? CalendarCellView  else {
            return
        }
        
        if cellState.isSelected {
            myCustomCell.dayLabel.textColor = darkPurple
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dayLabel.textColor = white
            } else {
                myCustomCell.dayLabel.textColor = dimPurple
            }
        }
    }
    
    /// Handle the calendar selection
    ///
    /// - Parameters:
    ///   - view: calendar view
    ///   - cellState: state of each cell
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {
        guard let myCustomCell = view as? CalendarCellView  else {
            return
        }
        if cellState.isSelected {
            myCustomCell.selectedView.layer.cornerRadius =  25
            myCustomCell.selectedView.isHidden = false
        } else {
            myCustomCell.selectedView.isHidden = true
        }
    }
    
    // MARK: - Header protocol
    
    /// Sets the height of header
    ///
    /// - Parameters:
    ///   - calendar: the calendar type
    ///   - range: time range
    ///   - month: calendar's month
    /// - Returns: the height
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        return CGSize(width: 200, height: 70)
    }
    
    // This setups the display of your header
    /// Setups the display of header
    ///
    /// - Parameters:
    ///   - calendar: calendar type
    ///   - header: related header
    ///   - range: time range
    //   - identifier: header id
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
        let headerCell = (header as? CalendarHeader)
        headerCell?.month.text = DateManager.getMonth(date: range.start)
    }
    
    // MARK: - Actions

    /// Go back to the previous page
    ///
    /// - Parameter sender: who send the action
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UIColor {
    
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
