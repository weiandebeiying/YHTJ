import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuel_cost_statistics/easyLoding/theme.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({
    Key key,
  }) : super(key: key);

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  final double _size = EasyLoadingTheme.indicatorSize;

  /// indicator color of loading
  final Color _indicatorColor = EasyLoadingTheme.indicatorColor;

  Widget _indicator;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _indicator = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = _size;
    _indicator = CircularProgressIndicator();

    return Container(
      constraints: BoxConstraints(
        maxWidth: _width,
      ),
      child: _indicator,
    );
  }
}
