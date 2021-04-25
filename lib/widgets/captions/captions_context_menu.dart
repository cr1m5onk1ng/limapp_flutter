import 'package:easy_popup/easy_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:limapp/application/providers/dictionary/dictionary_providers.dart';
import 'package:limapp/widgets/dictionary/dictionary_popup.dart';

class _TextSelectionToolbarItemData {
  const _TextSelectionToolbarItemData({
    this.label,
    this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;
}

class CaptionTextContainer extends StatefulWidget {
  const CaptionTextContainer(this.text);
  final String text;

  @override
  _CaptionTextContainerState createState() => _CaptionTextContainerState();
}

class _CaptionTextContainerState extends State<CaptionTextContainer> {
  @override
  Widget build(BuildContext context) {
    return SelectableText(
      widget.text,
      selectionControls: CaptionTextSelectionControls(),
      style: TextStyle(
        color: Colors.black,
        fontFamily: GoogleFonts.roboto().fontFamily,
        fontSize: 20,
      ),
    );
  }
}

class CaptionTextSelectionControls extends MaterialTextSelectionControls {
  // Padding between the toolbar and the anchor.
  static const double _kToolbarContentDistanceBelow = 20.0;
  static const double _kToolbarContentDistance = 8.0;

  /// Builder for material-style copy/paste text selection toolbar.
  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset selectionMidpoint,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ClipboardStatusNotifier clipboardStatus,
  ) {
    final TextSelectionPoint startTextSelectionPoint = endpoints[0];
    final TextSelectionPoint endTextSelectionPoint =
        endpoints.length > 1 ? endpoints[1] : endpoints[0];
    final Offset anchorAbove = Offset(
        globalEditableRegion.left + selectionMidpoint.dx,
        globalEditableRegion.top +
            startTextSelectionPoint.point.dy -
            textLineHeight -
            _kToolbarContentDistance);
    final Offset anchorBelow = Offset(
      globalEditableRegion.left + selectionMidpoint.dx,
      globalEditableRegion.top +
          endTextSelectionPoint.point.dy +
          _kToolbarContentDistanceBelow,
    );

    return Consumer(
      builder: (context, watch, child) {
        final dictionaryStateNotifier = watch(dictionaryStateNotifierProvider);
        return CaptionsTextSelectionToolbar(
          anchorAbove: anchorAbove,
          anchorBelow: anchorBelow,
          clipboardStatus: clipboardStatus,
          handleCopy: canCopy(delegate) && handleCopy != null
              ? () => handleCopy(delegate, clipboardStatus)
              : null,
          handleDictionarySearch: () {
            final TextEditingValue value = delegate.textEditingValue;
            var text = value.selection.textInside(value.text);
            dictionaryStateNotifier.searchWord(text);
            delegate.bringIntoView(delegate.textEditingValue.selection.extent);
            delegate.hideToolbar();

            EasyPopup.show(
              context,
              DictionaryPopUp(),
              cancelable: true,
              darkEnable: true,
            );
          },
          handleCut: canCut(delegate) && handleCut != null
              ? () => handleCut(delegate)
              : null,
          handlePaste: canPaste(delegate) && handlePaste != null
              ? () => handlePaste(delegate)
              : null,
          handleSelectAll: canSelectAll(delegate) && handleSelectAll != null
              ? () => handleSelectAll(delegate)
              : null,
        );
      },
    );
  }
}

class CaptionsTextSelectionToolbar extends StatefulWidget {
  const CaptionsTextSelectionToolbar({
    Key key,
    this.anchorAbove,
    this.anchorBelow,
    this.clipboardStatus,
    this.handleCopy,
    this.handleDictionarySearch,
    this.handleCut,
    this.handlePaste,
    this.handleSelectAll,
  }) : super(key: key);

  final Offset anchorAbove;
  final Offset anchorBelow;
  final ClipboardStatusNotifier clipboardStatus;
  final VoidCallback handleCopy;
  final VoidCallback handleDictionarySearch;
  final VoidCallback handleCut;
  final VoidCallback handlePaste;
  final VoidCallback handleSelectAll;

  @override
  CaptionsTextSelectionToolbarState createState() =>
      CaptionsTextSelectionToolbarState();
}

class CaptionsTextSelectionToolbarState
    extends State<CaptionsTextSelectionToolbar> {
  void _onChangedClipboardStatus() {
    setState(() {
      // Inform the widget that the value of clipboardStatus has changed.
    });
  }

  @override
  void initState() {
    super.initState();
    widget.clipboardStatus.addListener(_onChangedClipboardStatus);
    widget.clipboardStatus.update();
  }

  @override
  void didUpdateWidget(CaptionsTextSelectionToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.clipboardStatus != oldWidget.clipboardStatus) {
      widget.clipboardStatus.addListener(_onChangedClipboardStatus);
      oldWidget.clipboardStatus.removeListener(_onChangedClipboardStatus);
    }
    widget.clipboardStatus.update();
  }

  @override
  void dispose() {
    super.dispose();
    if (!widget.clipboardStatus.disposed) {
      widget.clipboardStatus.removeListener(_onChangedClipboardStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);

    final List<_TextSelectionToolbarItemData> itemDatas =
        <_TextSelectionToolbarItemData>[
      if (widget.handleCut != null)
        _TextSelectionToolbarItemData(
          label: localizations.cutButtonLabel,
          onPressed: widget.handleCut,
        ),
      if (widget.handleCopy != null)
        _TextSelectionToolbarItemData(
          label: localizations.copyButtonLabel,
          onPressed: widget.handleCopy,
        ),
      if (widget.handlePaste != null &&
          widget.clipboardStatus.value == ClipboardStatus.pasteable)
        _TextSelectionToolbarItemData(
          label: localizations.pasteButtonLabel,
          onPressed: widget.handlePaste,
        ),
      if (widget.handleSelectAll != null)
        _TextSelectionToolbarItemData(
          label: localizations.selectAllButtonLabel,
          onPressed: widget.handleSelectAll,
        ),
      _TextSelectionToolbarItemData(
        onPressed: widget.handleDictionarySearch,
        label: 'Search in dictionary',
      ),
    ];

    int childIndex = 0;
    return TextSelectionToolbar(
      anchorAbove: widget.anchorAbove,
      anchorBelow: widget.anchorBelow,
      toolbarBuilder: (BuildContext context, Widget child) {
        return Container(
          color: Colors.white,
          child: child,
        );
      },
      children: itemDatas.map((_TextSelectionToolbarItemData itemData) {
        return TextSelectionToolbarTextButton(
          padding: TextSelectionToolbarTextButton.getPadding(
              childIndex++, itemDatas.length),
          onPressed: itemData.onPressed,
          child: Text(itemData.label),
        );
      }).toList(),
    );
  }
}
