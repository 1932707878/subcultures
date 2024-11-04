// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  /// 显示内容
  final String text;

  /// 最大显示行数
  final int maxLines;

  /// 显示内容样式
  final TextStyle? contentStyle;

  /// 展开按钮样式
  final TextStyle? expandFuncStyle;

  const ExpandableText({
    super.key,
    required this.text,
    this.maxLines = 3,
    this.contentStyle,
    this.expandFuncStyle,
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final span = TextSpan(text: widget.text);
            final tp = TextPainter(
              text: span,
              textDirection: TextDirection.ltr,
              maxLines: widget.maxLines,
            );
            tp.layout(maxWidth: constraints.maxWidth);
            // 是否溢出
            final overflow = tp.didExceedMaxLines;
            if (!overflow || _isExpanded) {
              // 未溢出|未展开
              return Text(
                widget.text,
                style: widget.contentStyle,
              );
            } else {
              // 溢出显示指定行数
              final truncatedText =
                  '${tp.text!.toPlainText().substring(0, tp.text!.toPlainText().length - 4)}...';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    truncatedText,
                    style: widget.contentStyle,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      _isExpanded ? '收起' : '展开',
                      style: widget.expandFuncStyle,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}
