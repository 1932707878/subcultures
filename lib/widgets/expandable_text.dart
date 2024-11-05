// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  /// 显示内容
  final String text;

  final bool expendable;

  /// 最大显示行数
  final int maxLines;

  /// 显示内容样式
  final TextStyle? contentStyle;

  /// 展开按钮样式
  final TextStyle? expandFuncStyle;

  const ExpandableText({
    super.key,
    required this.text,
    this.expendable = true,
    this.maxLines = 3,
    this.contentStyle,
    this.expandFuncStyle = const TextStyle(
      color: Colors.blueAccent,
      fontSize: 16,
    ),
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;
  late int _textLineCount;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calculateTextLineCount();
  }

  void _calculateTextLineCount() {
    final textStyle = DefaultTextStyle.of(context).style;
    final textSpan = TextSpan(text: widget.text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: null,
    );
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);
    _textLineCount = textPainter.computeLineMetrics().length;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            widget.text,
            maxLines: widget.maxLines,
            overflow: TextOverflow.ellipsis,
            style: widget.contentStyle,
          ),
          secondChild: Text(widget.text, style: widget.contentStyle),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        if (widget.expendable && _textLineCount > widget.maxLines)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'Fold' : 'Unfold',
              style: widget.expandFuncStyle,
            ),
          ),
      ],
    );
  }
}
