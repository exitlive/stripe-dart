// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library web.parameters;

import 'dart:html';

import 'package:polymer/polymer.dart';

import 'package:dartdoc_viewer/item.dart';

import 'type.dart';
import 'parameters.dart';

/**
 * An element representing a function that is passed in as a parameter to a
 * method.
 */
@CustomTag("dartdoc-closure")
class ClosureElement extends PolymerElement with ChangeNotifier  {
  @reflectable @observable Closure get closure => __$closure; Closure __$closure; @reflectable set closure(Closure value) { __$closure = notifyPropertyChange(#closure, __$closure, value); }

  factory ClosureElement() => new Element.tag('dartdoc-closure');
  ClosureElement.created() : super.created();

  void closureChanged() {
    this.children.clear();

    var outerSpan = new SpanElement();
    if (!closure.returnType.isDynamic) {
      outerSpan.append(new TypeElement()..type = closure.returnType);
      outerSpan.appendText(' ');
    }

    var parameterName = new AnchorElement()
              ..text = closure.name
              ..href = closure.prefixedAnchorHref
              ..id = closure.anchorHrefLocation.anchor;

    outerSpan.append(parameterName);
    outerSpan.append(new ParameterElement()
      ..parameters = closure.parameters);
    this.append(outerSpan);
  }
}
