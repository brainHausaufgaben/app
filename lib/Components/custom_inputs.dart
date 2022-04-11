import 'package:flutter/material.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

class CustomTextField extends TextField {
  CustomTextField({
    Key? key,
    required controller,
    required placeHolder,
    autocorrect
  }) : super(
    key: key,
    autocorrect: autocorrect,
    controller: controller,
    style: AppDesign.current.textStyles.input,
    decoration: InputDecoration (
      filled: true,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppDesign.current.textStyles.color
        )
      ),
      fillColor: AppDesign.current.boxStyle.backgroundColor,
      label: Text(placeHolder, style: AppDesign.current.textStyles.input),
    ),
  );
}

class CustomDropdown<ItemType> extends StatelessWidget {
  CustomDropdown({
    Key? key,
    required this.defaultText,
    required this.currentValue,
    required this.items,
    required this.onChanged
  }) : super(key: key);

  Widget defaultText;
  ItemType currentValue;
  List<DropdownMenuItem<ItemType>> items;
  void Function(dynamic)? onChanged;

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
}

class CustomDateButton extends StatelessWidget {
  CustomDateButton({
    Key? key,
    required this.value,
    required this.onDateSelect,
    required this.text
  }) : super(key: key);

  Function(DateTime) onDateSelect;
  DateTime value;
  String text;

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
    return TextButton(
      style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: AppDesign.current.boxStyle.backgroundColor
      ),
      onPressed: () {
        Future<DateTime?> newDateTime = showRoundedDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 1),
            lastDate: DateTime(DateTime.now().year + 1),
            borderRadius: 16,
            theme: AppDesign.current.themeData,
            height: 300,
            styleDatePicker: MaterialRoundedDatePickerStyle(
              paddingMonthHeader: const EdgeInsets.all(11),
              backgroundPicker: AppDesign.current.boxStyle.backgroundColor,
              textStyleDayOnCalendar: TextStyle(color: AppDesign.current.textStyles.color),
              textStyleMonthYearHeader: TextStyle(color: AppDesign.current.textStyles.color),
              textStyleDayHeader: TextStyle(color: AppDesign.current.textStyles.color),
              colorArrowNext: AppDesign.current.textStyles.color,
              colorArrowPrevious: AppDesign.current.textStyles.color,
            )
        );
        newDateTime.then((value) => onDateSelect(value!));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value.year == 10 ? text : getDateString(value), style: AppDesign.current.textStyles.input),
            Icon(Icons.date_range, color: AppDesign.current.textStyles.color),
          ],
        ),
      ),
    );
  }
}

class CustomColorPicker extends StatelessWidget {
  CustomColorPicker({
    Key? key,
    required this.pickerColor,
    required this.onColorSelect
  }) : super(key: key);

  Color pickerColor;
  Function(Color) onColorSelect;

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
            builder: (BuildContext _test) {
              return AlertDialog(
                title: const Text("Farbe auswählen"),
                content: MaterialPicker(pickerColor: pickerColor, onColorChanged: onColorSelect),
              );
            }
        );
        }
    );
  }
}

class SettingsNavigatorButton extends StatelessWidget {
  SettingsNavigatorButton({
    Key? key,
    required this.text,
    required this.action
  }) : super(key: key);

  String text;
  Function() action;

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

class SettingsSwitchButton extends StatefulWidget {
  SettingsSwitchButton({
    Key? key,
    required this.text,
    required this.action
  }) : super(key: key);

  String text;
  Function() action;

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
                    color: AppDesign.darkMode ? AppDesign.current.textStyles.color : Colors.transparent,
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
  SettingsEntry({
    Key? key,
    required this.children
  }) : super(key: key);

  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
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

class ColorThemeSelection extends StatelessWidget {
  ColorThemeSelection({Key? key}) : super(key: key);

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

