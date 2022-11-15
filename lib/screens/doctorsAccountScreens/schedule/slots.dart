import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/constants/responsive.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/shared/animatedButton.dart';
import 'package:doctor_consultation/shared/customButtonStyle.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';

class Slots extends StatefulWidget {
  final DateTime time;
  const Slots({Key key, this.time}) : super(key: key);

  @override
  State<Slots> createState() => _SlotsState();
}

class _SlotsState extends State<Slots> {
  String _dropDownValue;
  List<int> item = [15, 30, 45, 60, 75, 90];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.schedule),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            //  mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DropdownButton(
                hint: _dropDownValue == null
                    ? const Text('15 Minutes')
                    : Text(
                        '  $_dropDownValue Minutes',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 18, 19, 19)),
                      ),
                isExpanded: true,
                iconSize: 30.0,
                style: const TextStyle(color: Color.fromARGB(255, 3, 3, 3)),
                items: item.map(
                  (val) {
                    return DropdownMenuItem<String>(
                      value: val.toString(),
                      child: Text(' $val Minutes'),
                    );
                  },
                ).toList(),
                onChanged: (val) {
                  setState(
                    () {
                      _dropDownValue = val;
                      LocatorService.appointmentSetupProvider()
                          .slots(DateTime.now(), int.parse(val));
                    },
                  );
                },
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 20,
              ),
              Container(
                height: Responsive.height(55, context),
                // width: Responsive.width(200, context),
                child: GridView.builder(
                  itemCount: LocatorService.appointmentSetupProvider()
                      .timeSlots
                      .length,
                  itemBuilder: (context, index) => ItemTile(index),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 2,
                      crossAxisSpacing: 4),
                ),
              ),
              const Spacer(),
              Container(
                height: Responsive.height(7, context),
                width: double.infinity,
                child: AnimButton(
                  onTap: () {
                    LocatorService.appointmentSetupProvider().eventList.add(
                          NeatCleanCalendarEvent('Appointment Slots',
                              startTime: DateTime(widget.time.year,
                                  widget.time.month, widget.time.day, 10, 0),
                              endTime: DateTime(
                                  widget.time.year,
                                  widget.time.month,
                                  widget.time.day + 2,
                                  12,
                                  0),
                              color: Colors.orange,
                              isMultiDay: true),
                        );
                    // // Removes the keyborad
                    // FocusScope.of(context).unfocus();
                    // onPress();
                  },
                  child: CustomButtonStyle(
                    color: _theme.primaryColorLight.withOpacity(0.6),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppStrings.ok,
                        style: _theme.textTheme.button
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  ItemTile(int index) {
    return Container(
      // height: 10, // Responsive.height(5, context),
      // width: Responsive.width(35, context),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey)),
      child: Center(
          child:
              Text(LocatorService.appointmentSetupProvider().timeSlots[index])),
    );
  }
}



// class ItemTile extends StatelessWidget {
//   final int itemNo;

//   const ItemTile(
//     this.itemNo,
//   );

//   @override
//   Widget build(BuildContext context) {
//     final Color color = Colors.primaries[itemNo % Colors.primaries.length];
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ListTile(
//         tileColor: color.withOpacity(0.3),
//         onTap: () {},
//         leading: Container(
//           width: 50,
//           height: 30,
//           color: color.withOpacity(0.5),
//           child: Placeholder(
//             color: color,
//           ),
//         ),
//         title: Text(
//           'Product $itemNo',
//           style: TextStyle(color: Colors.black),
//           //   key: Key('text_$itemNo'),
//         ),
//       ),
//     );
//   }
// }
