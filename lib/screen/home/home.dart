import 'package:custom_calendar/screen/calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/utils/responsive/responsiveness.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFirst = '';
  late DateTime selectFirstDate;
  String selectedSecond = '';
  late DateTime selectSecondDate;
  String selectedThird = '';
  late DateTime selectThirdDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20.hs,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Calendar widgets',
                ),
                SizedBox(
                  height: 20.h,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(40.h), // NEW
                  ),
                  child: const Text(
                    'Without preset',
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          contentPadding: EdgeInsets.zero,
                          insetPadding: EdgeInsets.symmetric(horizontal: 10.hs),
                          children: <Widget>[
                            CalendarScreen(
                              saveDate: (date) {
                                setState(() {
                                  selectedFirst =
                                      DateFormat('dd MMM yyyy').format(date);
                                  selectFirstDate = date;
                                });
                              },
                              selectedDate: selectedFirst.isNotEmpty
                                  ? selectFirstDate
                                  : null,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                selectedDate(
                  onTap: () {
                    setState(() {
                      selectedFirst = '';
                    });
                  },
                  selectedDate: selectedFirst,
                ),
                SizedBox(
                  height: 20.h,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(40.h), // NEW
                  ),
                  child: const Text(
                    'With 4 presets',
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          contentPadding: EdgeInsets.zero,
                          insetPadding: EdgeInsets.symmetric(horizontal: 10.hs),
                          children: <Widget>[
                            CalendarScreen(
                              saveDate: (date) {
                                setState(() {
                                  selectedSecond =
                                      DateFormat('dd MMM yyyy').format(date);
                                  selectSecondDate = date;
                                });
                              },
                              selectedDate: selectedSecond.isNotEmpty
                                  ? selectSecondDate
                                  : null,
                              with4presets: true,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                selectedDate(
                  onTap: () {
                    setState(() {
                      selectedSecond = '';
                    });
                  },
                  selectedDate: selectedSecond,
                ),
                SizedBox(
                  height: 20.h,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(40.h), // NEW
                  ),
                  child: const Text(
                    'With 6 presets',
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          contentPadding: EdgeInsets.zero,
                          insetPadding: EdgeInsets.symmetric(horizontal: 10.hs),
                          children: <Widget>[
                            CalendarScreen(
                              saveDate: (date) {
                                setState(() {
                                  selectedThird =
                                      DateFormat('dd MMM yyyy').format(date);
                                  selectThirdDate = date;
                                });
                              },
                              selectedDate: selectedThird.isNotEmpty
                                  ? selectThirdDate
                                  : null,
                              with6presets: true,
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
                selectedDate(
                  onTap: () {
                    setState(() {
                      selectedThird = '';
                    });
                  },
                  selectedDate: selectedThird,
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 3.5),
                const Text(
                  'Darsh Parikh',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget selectedDate({
    required String selectedDate,
    required VoidCallback onTap,
  }) {
    return Visibility(
      visible: selectedDate.isNotEmpty,
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          margin: EdgeInsets.only(top: 10.h),
          padding: EdgeInsets.all(10.s),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            color: Colors.blue[50],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.date_range,
                color: Colors.blue,
                size: 18.s,
              ),
              SizedBox(width: 5.w),
              Text(
                selectedDate,
                style: const TextStyle(
                  color: Colors.blue,
                ),
              ),
              SizedBox(width: 5.w),
              Icon(
                Icons.close,
                color: Colors.blue,
                size: 18.s,
              )
            ],
          ),
        ),
      ),
    );
  }
}
