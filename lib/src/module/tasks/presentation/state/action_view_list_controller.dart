import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

import '../action_view.dart';

final actionViewList = Provider(
  (ref) => [
    TaskView(
      title: 'Inbox',
      selectorText: 'IBX',
      icon: Icons.move_to_inbox_rounded,
      filter: CheckboxFilter(
        'Inbox',
        equals: true,
      ),
    ),
    TaskView(
      title: 'Cold',
      selectorText: 'CLD',
      icon: Icons.ac_unit_rounded,
      filter: CheckboxFilter(
        'Cold',
        equals: true,
      ),
    ),
  ],
);
