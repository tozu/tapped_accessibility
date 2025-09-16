import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

import 'package:tapped_accessibility/src/model/models.dart';
import 'package:tapped_accessibility/src/extensions/extensions.dart';
import 'package:tapped_accessibility/src/theme/theme.dart';

part 'focus_highlight/focus_highlight.dart'; // visible
part 'accessible_builder.dart';
part 'scrollable/accessible_arrow_key_scrollable.dart'; // visible
part 'scrollable/scrollable_list_focus_movement.dart';
part 'scrollable/hardware_keyboard_usage.dart';
