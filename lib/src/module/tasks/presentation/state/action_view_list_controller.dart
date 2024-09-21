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
      title: 'In Progress',
      selectorText: 'IPR',
      icon: Icons.play_arrow_rounded,
      filter: AndFilter(
        [
          StatusFilter(
            'Status',
            equals: 'In Progress',
          ),
          CheckboxFilter(
            'Is Organised?',
            equals: true,
            isFormulaProperty: true,
          ),
        ],
      ),
    ),
    TaskView(
      title: 'Do Next',
      selectorText: 'DNX',
      icon: Icons.skip_next_rounded,
      filter: AndFilter(
        [
          StatusFilter(
            'Status',
            equals: 'Do Next',
          ),
          CheckboxFilter(
            'Is Organised?',
            equals: true,
            isFormulaProperty: true,
          ),
        ],
      ),
    ),
    TaskView(
      title: 'One-off Tasks',
      selectorText: 'OOT',
      icon: Icons.checklist_rounded,
      filter: AndFilter(
        [
          CheckboxFilter(
            'Is Organised?',
            equals: true,
            isFormulaProperty: true,
          ),
          RelationFilter(
            'Project',
            contains: '7225c222fc134711a51a55cb765a90ba',
          ),
        ],
      ),
    ),
    TaskView(
      title: 'To-do',
      selectorText: 'TODO',
      icon: Icons.task_alt_rounded,
      filter: OrFilter(
        [
          StatusFilter(
            'Status',
            equals: 'To-do',
          ),
          StatusFilter(
            'Status',
            equals: 'Awaiting',
          ),
          StatusFilter(
            'Status',
            equals: 'Stalled',
          ),
        ],
      ),
    ),
    TaskView(
      title: 'Overdue',
      selectorText: 'OVD',
      icon: Icons.warning_amber_rounded,
      filter: CheckboxFilter(
        'Overdue',
        equals: true,
        isFormulaProperty: true,
      ),
    ),
    TaskView(
      title: 'Unorganised',
      selectorText: 'UNO',
      icon: Icons.category_outlined,
      filter: CheckboxFilter(
        'Is Organised?',
        equals: false,
        isFormulaProperty: true,
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
    TaskView(
      title: 'Someday/Maybe',
      selectorText: 'SMD',
      icon: Icons.lightbulb_outline,
      filter: RelationFilter(
        'Project',
        contains: '0747d5766d66401398620ed8ca50590f',
      ),
    ),
    TaskView(
      title: 'Action',
      selectorText: 'ACT',
      icon: Icons.rocket_launch,
      filter: RelationFilter(
        'Project',
        contains: 'ca52742e843f46a89428e0ce70877f07',
      ),
    ),
    TaskView(
      title: 'Notion db sdk',
      selectorText: 'NDB',
      icon: Icons.code,
      filter: RelationFilter(
        'Project',
        contains: '7b76a36fd5dc423990ecab67fe1dd9db',
      ),
    ),
    TaskView(
      title: 'Project Y',
      selectorText: 'PRY',
      icon: Icons.science,
      filter: RelationFilter(
        'Project',
        contains: '942667d1d73d45a6bbe38b32934ee131',
      ),
    ),
    const TaskView(
      title: 'All',
      selectorText: 'ALL',
      icon: Icons.apps_rounded,
    ),
  ],
);
