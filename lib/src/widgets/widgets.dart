import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

import 'package:tapped_accessibility/src/model/models.dart';
import 'package:tapped_accessibility/src/extensions/extensions.dart';
import 'package:tapped_accessibility/src/theme/theme.dart';

part 'focus_highlight/focus_highlight.dart';
part 'focus_highlight/__focus_highlight_indicator.dart';
part 'focus_highlight/__parent_rect_clipper.dart';

part 'accessible_builder.dart';
part 'scrollable/accessible_arrow_key_scrollable.dart';
part 'scrollable/scrollable_list_focus_movement.dart';
part 'scrollable/hardware_keyboard_usage.dart';
