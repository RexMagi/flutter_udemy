import 'package:flutter/material.dart';
import 'package:meals_app/widgets/components/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';

  final Function saveFilters;
  final Map<String, bool> currentFilters;

  const FiltersScreen(this.currentFilters, this.saveFilters);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _glutenFree = false;
  var _vegetarian = false;
  var _vegan = false;
  var _lactoseFree = false;

  @override
  void initState() {
    super.initState();
    _glutenFree = widget.currentFilters['gluten'];
    _vegetarian = widget.currentFilters['vegetarian'];
    _vegan = widget.currentFilters['vegan'];
    _lactoseFree = widget.currentFilters['lactose'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              widget.saveFilters({
                'gluten': _glutenFree,
                'lactose': _lactoseFree,
                'vegan': _vegan,
                'vegetarian': _vegetarian,
              });
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'Adjust your meal selection',
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Expanded(
              child: ListView(
            children: <Widget>[
              buildSwitchListTile(
                  'Gluten-free', 'Only include gluten-free meals.', _glutenFree,
                  (newValue) {
                setState(
                  () {
                    _glutenFree = newValue;
                  },
                );
              }),
              buildSwitchListTile('Lactose-free',
                  'Only include Lactose-free meals.', _lactoseFree, (newValue) {
                setState(
                  () {
                    _lactoseFree = newValue;
                  },
                );
              }),
              buildSwitchListTile(
                  'Vegetarian', 'Only include vegetarian meals.', _vegetarian,
                  (newValue) {
                setState(
                  () {
                    _vegetarian = newValue;
                  },
                );
              }),
              buildSwitchListTile('vegan', 'Only include vegan meals.', _vegan,
                  (newValue) {
                setState(
                  () {
                    _vegan = newValue;
                  },
                );
              })
            ],
          ))
        ],
      ),
    );
  }

  SwitchListTile buildSwitchListTile(
      String title, String subTitle, bool value, Function onchange) {
    return SwitchListTile(
        title: Text(title),
        subtitle: Text(subTitle),
        value: value,
        onChanged: onchange);
  }
}
