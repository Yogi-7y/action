import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

import '../action_view.dart';

final actionViewList = Provider(
  (ref) => [
    TaskView(
      title: 'Inbox',
      selectorText: 'I',
      filter: CheckboxFilter(
        'Inbox',
        equals: true,
      ),
    ),
    TaskView(
      title: 'Cold',
      selectorText: 'C',
      filter: CheckboxFilter(
        'Cold',
        equals: true,
      ),
    ),
  ],
);
