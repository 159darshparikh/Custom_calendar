import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '/screen/calendar/data.dart';
import '/utils/responsive/responsiveness.dart';

enum CalendarViews { dates, months, year }

class CalendarScreen extends StatefulWidget {
  final Function(DateTime) saveDate;
  final DateTime? selectedDate;
  final bool with4presets;
  final bool with6presets;
  const CalendarScreen({
    super.key,
    required this.saveDate,
    required this.selectedDate,
    this.with4presets = false,
    this.with6presets = false,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _currentDateTime;
  late DateTime _selectedDateTime;
  late List<Calendar> _sequentialDates;
  late int midYear;
  CalendarViews _currentView = CalendarViews.dates;
  final List<String> _weekDays = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN'
  ];
  final List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    final date = DateTime.now();
    _currentDateTime = DateTime(date.year, date.month);
    _selectedDateTime = widget.selectedDate != null
        ? widget.selectedDate!
        : DateTime(date.year, date.month, date.day);
    _sequentialDates = [];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _getCalendar());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.hs,
      ),
      // height: MediaQuery.of(context).size.height * 0.6,
      child: (_currentView == CalendarViews.dates)
          ? _datesView()
          : (_currentView == CalendarViews.months)
              ? _showMonthsList()
              : _yearsView(
                  midYear ?? _currentDateTime.year,
                ),
    );
  }

  // dates view
  Widget _datesView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        /// 4 presets
        Visibility(
          visible: widget.with4presets,
          child: Column(
            children: [
              option(
                isSelected: true,
                firstText: 'Never ends',
                secondText: '15 days later',
              ),
              option(
                isSelected: false,
                firstText: '30 days later',
                secondText: '60 days later',
              ),
            ],
          ),
        ),

        /// 6 presets
        Visibility(
          visible: widget.with6presets,
          child: Column(
            children: [
              option(
                isSelected: true,
                firstText: 'Yesterday',
                secondText: 'Today',
              ),
              option(
                isSelected: false,
                firstText: 'Tomorrow',
                secondText: 'This Saturday',
              ),
              option(
                isSelected: false,
                firstText: 'This Sunday',
                secondText: 'Next Tuesday',
              ),
            ],
          ),
        ),
        // header
        Row(
          children: <Widget>[
            // prev month button
            _toggleBtn(false),
            // month and year
            Expanded(
              child: Center(
                child: Text(
                  '${_monthNames[_currentDateTime.month - 1]} ${_currentDateTime.year}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.f,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // next month button
            _toggleBtn(true),
          ],
        ),
        const Divider(
          color: Colors.black,
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2.3,
          width: MediaQuery.of(context).size.width,
          child: _calendarBody(),
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.event,
                  color: Colors.blue,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  DateFormat('dd MMM yyyy').format(_selectedDateTime),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[50],
                    textStyle: const TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.saveDate(
                      _selectedDateTime,
                    );
                  },
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  // next / prev month buttons
  Widget _toggleBtn(bool next) {
    return InkWell(
      onTap: () {
        if (_currentView == CalendarViews.dates) {
          setState(() => (next) ? _getNextMonth() : _getPrevMonth());
        } else if (_currentView == CalendarViews.year) {
          if (next) {
            midYear =
                (midYear == null) ? _currentDateTime.year + 9 : midYear + 9;
          } else {
            midYear =
                (midYear == null) ? _currentDateTime.year - 9 : midYear - 9;
          }
          setState(() {});
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: 50.w,
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              offset: const Offset(3, 3),
              blurRadius: 3,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Icon(
          (next) ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
    );
  }

  // calendar
  Widget _calendarBody() {
    if (_sequentialDates == null) return Container();
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: _sequentialDates.length + 7,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 20,
        crossAxisCount: 7,
        crossAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        if (index < 7) return _weekDayTitle(index);
        if (_sequentialDates[index - 7].date == _selectedDateTime)
          return _selector(_sequentialDates[index - 7]);
        return _calendarDates(_sequentialDates[index - 7]);
      },
    );
  }

  // calendar header
  Widget _weekDayTitle(int index) {
    return Text(
      _weekDays[index],
      style: TextStyle(
        color: Colors.black,
        fontSize: 12.f,
      ),
    );
  }

  // calendar element
  Widget _calendarDates(Calendar calendarDate) {
    return InkWell(
      onTap: () {
        if (_selectedDateTime != calendarDate.date) {
          if (calendarDate.nextMonth) {
            _getNextMonth();
          } else if (calendarDate.prevMonth) {
            _getPrevMonth();
          }
          setState(() => _selectedDateTime = calendarDate.date!);
        }
      },
      child: Center(
          child: Text(
        '${calendarDate.date!.day}',
        style: TextStyle(
          color: (calendarDate.thisMonth)
              ? (calendarDate.date!.weekday == DateTime.sunday)
                  ? Colors.black
                  : Colors.black
              : (calendarDate.date!.weekday == DateTime.sunday)
                  ? Colors.black.withOpacity(0.5)
                  : Colors.black.withOpacity(0.5),
        ),
      )),
    );
  }

  // date selector
  Widget _selector(Calendar calendarDate) {
    return Container(
      width: 30.w,
      height: 30.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Colors.white,
          width: 4.w,
        ),
        gradient: LinearGradient(
          colors: [Colors.black.withOpacity(0.1), Colors.white],
          stops: const [0.1, 1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.9),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            '${calendarDate.date!.day}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  // get next month calendar
  void _getNextMonth() {
    if (_currentDateTime.month == 12) {
      _currentDateTime = DateTime(_currentDateTime.year + 1, 1);
    } else {
      _currentDateTime =
          DateTime(_currentDateTime.year, _currentDateTime.month + 1);
    }
    _getCalendar();
  }

  // get previous month calendar
  void _getPrevMonth() {
    if (_currentDateTime.month == 1) {
      _currentDateTime = DateTime(_currentDateTime.year - 1, 12);
    } else {
      _currentDateTime =
          DateTime(_currentDateTime.year, _currentDateTime.month - 1);
    }
    _getCalendar();
  }

  // get calendar for current month
  void _getCalendar() {
    _sequentialDates = CustomCalendar().getMonthCalendar(
        _currentDateTime.month, _currentDateTime.year,
        startWeekDay: StartWeekDay.monday);
  }

  // show months list
  Widget _showMonthsList() {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () => setState(() => _currentView = CalendarViews.year),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              '${_currentDateTime.year}',
              style: TextStyle(
                fontSize: 18.f,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const Divider(
          color: Colors.black,
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _monthNames.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                _currentDateTime = DateTime(_currentDateTime.year, index + 1);
                _getCalendar();
                setState(() => _currentView = CalendarViews.dates);
              },
              title: Center(
                child: Text(
                  _monthNames[index],
                  style: TextStyle(
                    fontSize: 18.f,
                    color: (index == _currentDateTime.month - 1)
                        ? Colors.blue
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // years list views
  Widget _yearsView(int midYear) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            _toggleBtn(false),
            const Spacer(),
            _toggleBtn(true),
          ],
        ),
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: 9,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (context, index) {
              int thisYear;
              if (index < 4) {
                thisYear = midYear - (4 - index);
              } else if (index > 4) {
                thisYear = midYear + (index - 4);
              } else {
                thisYear = midYear;
              }
              return ListTile(
                onTap: () {
                  _currentDateTime = DateTime(thisYear, _currentDateTime.month);
                  _getCalendar();
                  setState(() => _currentView = CalendarViews.months);
                },
                title: Text(
                  '$thisYear',
                  style: TextStyle(
                    fontSize: 18.f,
                    color: (thisYear == _currentDateTime.year)
                        ? Colors.blue
                        : Colors.black,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget option({
    required bool isSelected,
    required String firstText,
    required String secondText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: unSelectedOption(
            text: firstText,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: isSelected
              ? ElevatedButton(
                  child: Text(secondText),
                  onPressed: () {},
                )
              : unSelectedOption(
                  text: secondText,
                ),
        ),
      ],
    );
  }

  Widget unSelectedOption({
    required String text,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[50],
        textStyle: const TextStyle(
          color: Colors.blue,
        ),
      ),
      onPressed: () {},
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.blue,
        ),
      ),
    );
  }
}
