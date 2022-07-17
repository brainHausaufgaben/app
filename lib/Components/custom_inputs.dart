import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:flutter/material.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';

class BrainTextField extends StatefulWidget {
  BrainTextField({
    Key? key,
    required this.controller,
    required this.placeholder,
    this.minLines,
    this.maxLines,
    this.maxLength
  }) : super(key: key);

  TextEditingController controller;
  String placeholder;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;

  @override
  State<StatefulWidget> createState() => _BrainTextField();
}

class _BrainTextField extends State<BrainTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppDesign.current.boxStyle.inputBorderRadius
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          TextField(
            minLines: widget.minLines ?? 1,
            maxLines: widget.maxLines ?? 5,
            autocorrect: true,
            controller: widget.controller,
            style: AppDesign.current.textStyles.input,
            decoration: InputDecoration (
              filled: true,
              enabledBorder: UnderlineInputBorder(
                  borderRadius: AppDesign.current.boxStyle.inputBorderRadius,
                  borderSide: BorderSide(
                      width: 4,
                      color: AppDesign.current.textStyles.color
                  )
              ),
              fillColor: AppDesign.current.boxStyle.backgroundColor,
              label: Text(
                  widget.placeholder,
                  style: AppDesign.current.textStyles.input
              ),
            ),
            inputFormatters: widget.maxLength != null ? [
              LengthLimitingTextInputFormatter(widget.maxLength),
            ] : null,
            onChanged: (_) => setState(() {}),
          ),
          if (widget.maxLength != null) Positioned(
            right: 10,
            top: 9,
            child: Text(
                "${widget.controller.text.length.toString()}/${widget.maxLength}",
                style: TextStyle(
                    color: AppDesign.current.textStyles.color,
                    fontSize: 10
                )
            ),
          )
        ],
      ),
    );
  }
}

class CustomDropdown<ItemType> extends StatelessWidget {
  const CustomDropdown({
    Key? key,
    required this.defaultText,
    required this.currentValue,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  final Widget defaultText;
  final ItemType currentValue;
  final List<DropdownMenuItem<ItemType>> items;
  final void Function(dynamic)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: AppDesign.current.boxStyle.inputBorderRadius,
            color: AppDesign.current.boxStyle.backgroundColor
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: DropdownButton<dynamic>(
            iconEnabledColor: AppDesign.current.textStyles.color,
            isDense: true,
            underline: Container(),
            isExpanded: true,
            dropdownColor: AppDesign.current.boxStyle.backgroundColor,
            style: AppDesign.current.textStyles.input,
            value: currentValue,
            hint: defaultText,
            items: items,
            onChanged: onChanged,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        )
    );
  }

  static List<DropdownMenuItem<Subject>> getSubjectDropdowns(){
    List<DropdownMenuItem<Subject>> subjects = [];
    for(Subject subject in TimeTable.subjects){
      subjects.add(
          DropdownMenuItem<Subject>(
            alignment: Alignment.bottomCenter,
            child: PointElement(primaryText: subject.name, color: subject.color),
            value: subject,
          )
      );
    }
    return subjects;
  }
}

class CustomDateButton extends StatelessWidget {
  const CustomDateButton({
    Key? key,
    required this.value,
    required this.onDateSelect,
    required this.text,
    this.selectedSubject,
  }) : super(key: key);

  final Function(DateTime) onDateSelect;
  final Subject? selectedSubject;
  final DateTime value;
  final String text;

  String getDateString(DateTime date){
    List weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"];
    String day = date.day.toString();
    String month = date.month.toString();
    String year = date.year.toString();
    String weekDay =  weekDays[date.weekday - 1];
    return weekDay + ", " + day + "." + month + "." + year;
  }

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      child: Text(value.year == 10 ? text : getDateString(value), style: AppDesign.current.textStyles.input),
      icon: Icons.date_range,
      action: () {
        Future<DateTime?> newDateTime = showRoundedDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 1)),
            lastDate: DateTime(DateTime.now().year + 1),
            borderRadius: 10,
            theme: AppDesign.current.themeData,
            height: 300,
            styleDatePicker: MaterialRoundedDatePickerStyle(
              paddingMonthHeader: const EdgeInsets.all(11),
              backgroundPicker: AppDesign.current.boxStyle.backgroundColor,
              textStyleDayOnCalendar: TextStyle(color: AppDesign.current.textStyles.color),
              textStyleDayOnCalendarDisabled: TextStyle(color: AppDesign.current.textStyles.color.withOpacity(0.5)),
              textStyleMonthYearHeader: TextStyle(color: AppDesign.current.textStyles.color),
              textStyleDayHeader: TextStyle(color: AppDesign.current.textStyles.color),
              colorArrowNext: AppDesign.current.textStyles.color,
              colorArrowPrevious: AppDesign.current.textStyles.color,
            ),
            builderDay: (DateTime dateTime, bool isCurrentDay, bool isSelected, TextStyle defaultTextStyle) {
              // Default
              if (isSelected) {
                return Container(
                  decoration: BoxDecoration(color: AppDesign.current.primaryColor, shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      dateTime.day.toString(),
                      style: defaultTextStyle,
                    )
                  )
                );
              }

              if (selectedSubject != null) {
                DateTime now = DateTime.now();

                if (dateTime.day >= now.day || dateTime.month > now.month) {
                  if (TimeTable.getSubjectsByDate(dateTime).contains(selectedSubject)) {
                    return Container(
                        decoration: BoxDecoration(
                          color: selectedSubject!.color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: Text(dateTime.day.toString(), style: defaultTextStyle)
                        )
                    );
                  }
                }
              }
              // Default
              return Center(
                child: Text(
                  dateTime.day.toString(),
                  style: defaultTextStyle,
                )
              );
            }
        );
        newDateTime.then((_value) => onDateSelect(_value ?? value));
      }
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    required this.action,
    required this.child,
    required this.icon,
    this.dense = false
  }) : super(key: key);

  final Function() action;
  final Widget child;
  final IconData icon;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppDesign.current.boxStyle.inputBorderRadius
      ),
      clipBehavior: Clip.antiAlias,
      child: TextButton(
        onPressed: action,
        style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: dense ? 11 : 14, horizontal: 12),
            backgroundColor: AppDesign.current.boxStyle.backgroundColor
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: child
            ),
            Icon(icon, color: AppDesign.current.textStyles.color, size: dense ? 20 : 24),
          ],
        ),
      ),
    );
  }
}

class CustomColorPicker extends StatelessWidget {
  const CustomColorPicker({
    Key? key,
    required this.pickerColor,
    required this.onColorSelect
  }) : super(key: key);

  final Color pickerColor;
  final Function(Color) onColorSelect;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppDesign.current.boxStyle.inputBorderRadius,
            color: AppDesign.current.boxStyle.backgroundColor
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          child: Row(
            children: [
              Container(
                height: 25.0,
                width: 25.0,
                decoration: BoxDecoration(
                  borderRadius: AppDesign.current.boxStyle.inputBorderRadius,
                  color: pickerColor
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("Farbe", style: AppDesign.current.textStyles.input),
              )
            ],
          ),
        ),
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
        ),
        onPressed: () {showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Farbe auswählen", style: TextStyle(color: AppDesign.current.textStyles.color)),
                backgroundColor: AppDesign.current.boxStyle.backgroundColor,
                content: MaterialPicker(
                  pickerColor: pickerColor,
                  onColorChanged: onColorSelect
                ),
              );
            }
        );
        }
    );
  }
}

class SettingsNavigatorButton extends StatelessWidget {
  const SettingsNavigatorButton({
    Key? key,
    required this.text,
    required this.action
  }) : super(key: key);

  final String text;
  final Function() action;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: action,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: AppDesign.current.textStyles.settingsSubMenu),
          Icon(Icons.arrow_forward_ios_rounded, color: AppDesign.current.textStyles.color, size: 20)
        ],
      ),
    );
  }
}

class SettingsLinkButton extends StatelessWidget {
  const SettingsLinkButton({
    Key? key,
    required this.text,
    required this.link
  }) : super(key: key);

  final String text;
  final String link;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Uri url = Uri.parse(link);
        launchUrl(url, mode: LaunchMode.externalApplication);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: AppDesign.current.textStyles.settingsSubMenu),
          Icon(Icons.open_in_browser, color: AppDesign.current.textStyles.color, size: 20)
        ],
      ),
    );
  }
}

class SettingsSwitchButton extends StatefulWidget {
  const SettingsSwitchButton({
    Key? key,
    required this.text,
    required this.action,
    required this.state
  }) : super(key: key);

  final String text;
  final Function() action;
  final bool state;

  @override
  State<StatefulWidget> createState() =>  _SettingsSwitchButton();
}

class _SettingsSwitchButton extends State<SettingsSwitchButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        widget.action();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.text, style: AppDesign.current.textStyles.settingsSubMenu),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: AppDesign.current.textStyles.color,
                width: 2
              )
            ),
            child: Center(
              child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: widget.state ? AppDesign.current.textStyles.color : Colors.transparent,
                    borderRadius: BorderRadius.circular(3)
                  ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SettingsEntry extends StatelessWidget {
  const SettingsEntry({
    Key? key,
    required this.children
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: AppDesign.current.boxStyle.backgroundColor,
        borderRadius: AppDesign.current.boxStyle.borderRadius
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class CustomMenuButton extends StatelessWidget {
  const CustomMenuButton({Key? key, required this.defaultAction}) : super(key: key);

  final Function() defaultAction;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      onPress: defaultAction,
      icon: Icons.add,
      activeIcon: Icons.close,
      children: [
        getHomeworkMenu(context),
        getEventMenu(context),
        getGradesMenu(context)
      ],
      overlayColor: Colors.black,
      overlayOpacity: 0.6,
      spacing: 5,
      childrenButtonSize: const Size(50, 50),
      childPadding: const EdgeInsets.only(right: 6),
      animationDuration: const Duration(milliseconds: 200),
    );
  }

  SpeedDialChild getHomeworkMenu(BuildContext context) {
    return SpeedDialChild(
        backgroundColor: AppDesign.current.primaryColor,
        foregroundColor: AppDesign.current.textStyles.contrastColor,
        labelBackgroundColor: AppDesign.current.primaryColor,
        labelStyle: TextStyle(color: AppDesign.current.textStyles.contrastColor),
        label: "Neue Hausaufgabe",
        child: const Icon(Icons.description_rounded),
        onTap: () {
          NavigationHelper.pushNamed("/homeworkPage");
        }
    );
  }

  SpeedDialChild getEventMenu(BuildContext context) {
    return SpeedDialChild(
        backgroundColor: AppDesign.current.primaryColor,
        foregroundColor: AppDesign.current.textStyles.contrastColor,
        labelBackgroundColor: AppDesign.current.primaryColor,
        labelStyle: TextStyle(color: AppDesign.current.textStyles.contrastColor),
        label: "Neues Event",
        child: const Icon(Icons.schedule_rounded),
        onTap: () {
          NavigationHelper.pushNamed("/eventsPage");
        }
    );
  }

  SpeedDialChild getGradesMenu(BuildContext context) {
    return SpeedDialChild(
        backgroundColor: AppDesign.current.primaryColor,
        foregroundColor: AppDesign.current.textStyles.contrastColor,
        labelBackgroundColor: AppDesign.current.primaryColor,
        labelStyle: TextStyle(color: AppDesign.current.textStyles.contrastColor),
        label: "Neue Note",
        child: const Icon(Icons.grading),
        onTap: () {
          NavigationHelper.pushNamed("/gradesPage");
        }
    );
  }
}

