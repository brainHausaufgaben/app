import 'package:brain_app/Backend/brain_vibrations.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/todo.dart';
import 'package:brain_app/Backend/todo_manager.dart';
import 'package:brain_app/Components/brain_confirmation_dialog.dart';
import 'package:brain_app/Components/brain_scroll_shadow.dart';
import 'package:flutter/material.dart';

import 'brain_inputs.dart';

class ToDoDialog extends StatefulWidget {
  const ToDoDialog({super.key});

  @override
  State<StatefulWidget> createState() => _ToDoDialog();
}

class _ToDoDialog extends State<ToDoDialog> {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  ToDoImportance importance = ToDoImportance.mid;

  List<Widget> getTodos() {
    Map<ToDoImportance, String> conversion = {
      ToDoImportance.high : "Wichtig",
      ToDoImportance.mid : "Mittel",
      ToDoImportance.low : "Unwichtig"
    };

    List<Widget> todos = [];
    for (ToDoItem todo in ToDoManager.getSorted()) {
      todos.add(
        SettingsSwitchButton(
          action: () {
            setState(() {
              ToDoManager.changeToDoState(todo, !todo.done);
              if(todo.done) BrainVibrations.successVibrate();
            });
          },
          state: todo.done,
          description: conversion[todo.importance],
          text: todo.content,
          style: todo.done ? AppDesign.textStyles.settingsSubMenu.copyWith(
            decoration: TextDecoration.lineThrough,
            color: AppDesign.colors.text06
          ) : null,
        )
      );
    }

    return todos;
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppDesign.colors.secondaryBackground,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("To Do", style: AppDesign.textStyles.alertDialogHeader),
          BrainTitleButton(
            icon: Icons.delete_forever,
            semantics: "Alle erledigten ToDos löschen",
            action: () {
              showDialog(context: context, builder: (context) {
                return BrainConfirmationDialog(
                  withCountdown: false,
                  description: "Willst du wirklich alle erledigten ToDos löschen?",
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                  onContinue: () {
                    setState(() {
                      for (ToDoItem todo in ToDoManager.getDoneStateToDos(true)) {
                        ToDoManager.deleteToDo(todo);
                      }
                    });
                    Navigator.of(context).pop();
                  }
                );
              });
            }
          )
        ]
      ),
      content: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 350, maxHeight: 500, maxWidth: 350),
          child: BrainScrollShadow(
            controller: scrollController,
            child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: AppDesign.colors.background,
                              borderRadius: AppDesign.boxStyle.inputBorderRadius
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(11),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                          child: BrainTextField(
                                              placeholder: "Neues To Do",
                                              controller: controller
                                          )
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor: AppDesign.colors.primary,
                                                  foregroundColor: AppDesign.colors.contrast,
                                                  padding: const EdgeInsets.all(8),
                                                  minimumSize: Size.zero
                                              ),
                                              child: const Icon(Icons.keyboard_arrow_right_rounded),
                                              onPressed: () {
                                                if (controller.text.isEmpty) return;
                                                setState(() {
                                                  ToDoManager.addToDo(
                                                      ToDoItem(controller.text, importance)
                                                  );
                                                  controller.clear();
                                                });
                                              }
                                          )
                                      )
                                    ]
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Wrap(
                                        runSpacing: 5,
                                        spacing: 7,
                                        direction: Axis.horizontal,
                                        children: [
                                          Container(
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),
                                                  color: importance == ToDoImportance.high
                                                      ? AppDesign.colors.primary
                                                      : AppDesign.colors.secondaryBackground
                                              ),
                                              child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      importance = ToDoImportance.high;
                                                    });
                                                  },
                                                  child: Text(
                                                      "Wichtig",
                                                      style: TextStyle(
                                                          color: importance == ToDoImportance.high
                                                              ? AppDesign.colors.contrast
                                                              : AppDesign.colors.text
                                                      )
                                                  )
                                              )
                                          ),
                                          Container(
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),
                                                  color: importance == ToDoImportance.mid
                                                      ? AppDesign.colors.primary
                                                      : AppDesign.colors.secondaryBackground
                                              ),
                                              child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      importance = ToDoImportance.mid;
                                                    });
                                                  },
                                                  child: Text(
                                                      "Mittel",
                                                      style: TextStyle(
                                                          color: importance == ToDoImportance.mid
                                                              ? AppDesign.colors.contrast
                                                              : AppDesign.colors.text
                                                      )
                                                  )
                                              )
                                          ),
                                          Container(
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),
                                                  color: importance == ToDoImportance.low
                                                      ? AppDesign.colors.primary
                                                      : AppDesign.colors.secondaryBackground
                                              ),
                                              child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      importance = ToDoImportance.low;
                                                    });
                                                  },
                                                  child: Text(
                                                      "Unwichtig",
                                                      style: TextStyle(
                                                          color: importance == ToDoImportance.low
                                                              ? AppDesign.colors.contrast
                                                              : AppDesign.colors.text
                                                      )
                                                  )
                                              )
                                          )
                                        ]
                                    )
                                )
                              ]
                          )
                      ),
                      ...getTodos()
                    ]
                )
            )
          )
      )
    );
  }
}