import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:work_log_fit/models/hive_entity.dart';
import 'package:work_log_fit/timer.dart';
import 'package:work_log_fit/settings.dart';

const themeColor = Color.fromRGBO(15, 59, 42, 1);
const themeColor2 = Color.fromRGBO(80, 200, 120, 1);

abstract class BaseListScreen<T> extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;
  final String boxName;
  final String emptyList;
  final String button1Name;
  final String button1Icon;
  String titleIcon;
  bool enableFirstButton; // custom buton
  bool enableDeleteButton;
  bool enableAddButton;
  bool showTimer;

  BaseListScreen({super.key,
    required this.title,
    required this.boxName,
    required this.emptyList,
    this.titleIcon = '',
    this.button1Name = 'Settings',
    this.button1Icon = 'Settings',
    this.enableDeleteButton = true,
    this.enableAddButton = true,
    this.enableFirstButton = true,
    this.showTimer = false,
  });

  @override
  final Size preferredSize = const Size.fromHeight(56.0);

  @override
  State<BaseListScreen<T>> createState();
}

abstract class BaseListScreenState<T extends HiveEntity>
    extends State<BaseListScreen<T>> {
  List<T> baseItemList = [];
  late Box<dynamic> baseItemBox;
  bool showDelete = false;
  late GlobalTimerManager timerManager;

  // to be overriden
  void itemSelected(BuildContext context, T item);
  String getItemString(T item);

  @override
  void initState() {
    super.initState();
    _initializeBoxAndLoadItems();
    timerManager = Provider.of<GlobalTimerManager>(context, listen: false);
    timerManager.updateTickCb(onTick: () => setState(() {}));
  }

  String formatTime(int seconds) {
    int min = seconds ~/ 60;
    int sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  void _initializeBoxAndLoadItems() async {
    var box = await Hive.openBox(widget.boxName);
    var items = await loadItems(box);
    setState(() {
      baseItemBox = box;
      baseItemList = items;
    });
  }

  @override
  Future<List<T>> loadItems(Box<dynamic> box) async {
    return box.values.cast<T>().toList().reversed.toList();
  }

  void addItem(T item) {
    baseItemBox.add(item);
    setState(() {
      baseItemList.insert(0, item);
    });
  }

  void updateItem(T item) {
    int key = item.key;
    baseItemBox.put(key, item);

    // Find the index of the item in the in-memory list
    int index = baseItemList.indexWhere((element) => element.key == key);
    if (index != -1) {
      setState(() {
        baseItemList[index] = item;
      });
    }
  }

  void deleteItem(T item) {
    baseItemBox.delete(item.key);
    setState(() {
      baseItemList.remove(item);
    });
  }

  @override
  T? createItem(String name) {
    return null;
  }

  @override
  void showAddItemDialog(BuildContext context) {
    TextEditingController textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Program'),
          content: TextField(
            controller: textFieldController,
            decoration: InputDecoration(hintText: "Program Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('ADD'),
              onPressed: () {
                if (textFieldController.text.isNotEmpty) {
                  T? item = createItem(textFieldController.text);
                  if (item != null) {
                    addItem(item);
                  }
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    ).then((_) {
      // This block is executed after the dialog is closed.
      timerManager.updateTickCb(onTick: () => setState(() {}));
    });
  }

  Widget printImage(String image) {
    return ClipOval(
      child: Container(
        color: Colors.transparent,
        width: 50.0,
        height: 50.0,
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  List<Widget> buildItemList(BuildContext context) {
    return baseItemList.map((item) {
      int index = baseItemList.indexOf(item);
      return ListTile(
        leading: printImage(item.getImageIcon()),
        title: Text(getItemString(item)),
        trailing: showDelete
            ? IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => deleteItem(item),
              )
            : null,
        onTap: () {
          if (!showDelete) {
            itemSelected(context, item);
          }
        },
      );
    }).toList();
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'Settings':
        return Icons.settings;
      case 'Monitoring':
        return Icons.show_chart;
      case 'fitness_center':
        return Icons.fitness_center;
      default:
        return Icons.error;
    }
  }

  void _toggleTimer() {
    if (timerManager.isTimerRunning) {
      timerManager.stopTimer();
    } else {
      timerManager.startTimer(onTick: () => setState(() {}));
    }

    // Force the widget to rebuild and update the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    int nextIndex = 0;

    int customIndex = widget.enableFirstButton ? nextIndex++ : -1;
    int deleteIndex = widget.enableDeleteButton ? nextIndex++ : -1;
    int addIndex = widget.enableAddButton ? nextIndex++ : -1;

    List<Widget> itemList = buildItemList(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (widget.titleIcon != '') ...[
              printImage(widget.titleIcon),
            ],
            Text(widget.title, style: TextStyle(color: themeColor2)),
            if (widget.showTimer) ...[
              Row(
                children: [
                  Text(
                    formatTime(timerManager.remainingSeconds),
                    style: TextStyle(
                      fontFamily: 'DigitalDisplay',
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    icon: Icon(timerManager.isTimerRunning
                        ? Icons.stop
                        : Icons.play_arrow),
                    onPressed: _toggleTimer,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      body: itemList.isEmpty
          ? Center(child: Text(widget.emptyList))
          : ListView(
              children: itemList,
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          if (widget.enableFirstButton)
            BottomNavigationBarItem(
              icon: Icon(_getIconFromString(widget.button1Icon)),
              label: widget.button1Name,
            ),
          if (widget.enableDeleteButton)
            BottomNavigationBarItem(
              icon: Icon(Icons.delete),
              label: 'Delete',
            ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor:
                  widget.enableAddButton ? themeColor : backgroundColor,
              child: Icon(Icons.add,
                  color:
                      widget.enableAddButton ? Colors.white : backgroundColor),
            ),
            label: widget.enableAddButton ? 'Add' : '',
          )
        ],
        onTap: (index) {
          if (index == deleteIndex) {
            setState(() {
              showDelete = !showDelete;
            });
          } else if (index == addIndex) {
            // Show add dialog
            showAddItemDialog(context);
          } else if (index == customIndex) {
            // Not implemtented
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    timerManager.updateTickCb(onTick: null);
    baseItemBox.close();
    super.dispose();
  }
}
