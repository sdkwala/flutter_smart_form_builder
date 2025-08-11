import 'package:flutter/material.dart';
import 'package:smart_form_builder/utils/decoration_builder.dart';

class RatingFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic) onChanged;

  const RatingFieldWidget({Key? key, required this.schema, required this.onChanged}) : super(key: key);

  @override
  State<RatingFieldWidget> createState() => _RatingFieldWidgetState();
}

class _RatingFieldWidgetState extends State<RatingFieldWidget> {
  double _rating = 0;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    final initialValue = widget.schema['defaultValue'];
    if (initialValue != null) {
      if (initialValue is int) {
        _rating = initialValue.toDouble();
      } else if (initialValue is double) {
        _rating = initialValue;
      } else if (initialValue is String) {
        _rating = double.tryParse(initialValue) ?? 0;
      }
    }
  }

  void _onRatingChanged(double value) {
    setState(() {
      _rating = value;
    });

    final keyName = widget.schema['key'];
    widget.onChanged(keyName, value.toDouble());
  }

  void _onHover(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    final schema = widget.schema;
    final keyName = schema['key'];
    final label = (schema['label'] ?? keyName)?.toString() ?? '';
    final validators = schema['validators'] ?? [];
    final maxRating = (schema['maxRating'] ?? 5).toDouble(); // Convert to double
    final ratingType = schema['ratingType'] ?? 'stars';
    final showLabels = schema['showLabels'] ?? false;
    final allowHalfRating = schema['allowHalfRating'] ?? false;
    final size = (schema['size'] ?? 32).toDouble();
    final spacing = (schema['spacing'] ?? 4).toDouble();
    final activeColor = schema['activeColor'] != null ? HexColor(schema['activeColor']) : Colors.amber;
    final inactiveColor = schema['inactiveColor'] != null ? HexColor(schema['inactiveColor']) : Colors.grey.shade300;

    // Rating labels
    final ratingLabels = schema['ratingLabels'] ?? {
      1: 'Poor',
      2: 'Fair',
      3: 'Good',
      4: 'Very Good',
      5: 'Excellent',
    };

    // Emoji ratings
    final emojiRatings = schema['emojiRatings'] ?? {
      1: '😞',
      2: '😐',
      3: '🙂',
      4: '😊',
      5: '😍',
    };

    Widget buildRatingItem(int index) {
    final isSelected = _rating >= index + 1;
    final isHalfSelected = allowHalfRating && _rating > index && _rating < index + 1;

    if (ratingType == 'emojis') {
      final emoji = emojiRatings[index + 1] ?? '⭐';
      return GestureDetector(
        onTap: () => _onRatingChanged((index + 1).toDouble()),
        onTapDown: (_) => _onHover(true),
        onTapUp: (_) => _onHover(false),
        onTapCancel: () => _onHover(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: _isHovering && _rating >= index + 1
              ? Matrix4.identity()
              : Matrix4.identity(),
          child: Text(
            emoji,
            style: TextStyle(
              fontSize: size,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
        ),
      );
    } else {
      // Stars
      return GestureDetector(
        onTap: () {
          if (allowHalfRating) {
            // For half rating, toggle between full and half
            if (_rating == index + 1.0) {
              _onRatingChanged(index + 0.5);
            } else if (_rating == index + 0.5) {
              _onRatingChanged(index + 1.0);
            } else {
              _onRatingChanged(index + 1.0);
            }
          } else {
            _onRatingChanged(index + 1.0);
          }
        },
        onTapDown: (_) => _onHover(true),
        onTapUp: (_) => _onHover(false),
        onTapCancel: () => _onHover(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: _isHovering && _rating >= index + 1
              ? Matrix4.identity()
              : Matrix4.identity(),
          child: Icon(
            isHalfSelected ? Icons.star_half : Icons.star,
            size: size,
            color: isSelected || isHalfSelected ? activeColor : inactiveColor,
          ),
        ),
      );
    }
  }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: schema['filled'] ?? false
                ? (schema['fillColor'] != null ? HexColor(schema['fillColor']) : Colors.grey.shade50)
                : null,
            borderRadius: BorderRadius.circular((schema['borderRadius'] ?? 8).toDouble()),
            border: schema['border'] == 'outline'
                ? Border.all(
                    color: HexColor(schema['borderColor'] ?? '#E0E0E0'),
                    width: 1,
                  )
                : null,
          ),
          child: Column(
            children: [
              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(maxRating.toInt(), (index) {
                    return Padding(
                      padding: EdgeInsets.only(right: index < maxRating - 1 ? spacing : 0),
                      child: buildRatingItem(index),
                    );
                  }),
                ),
                scrollDirection: Axis.horizontal,
              ),
              if (showLabels && _rating > 0) ...[
                const SizedBox(height: 8),
                Text(
                  ratingLabels[_rating.toInt()] ?? 'Rating: $_rating',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: activeColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              if (allowHalfRating && _rating > 0) ...[
                const SizedBox(height: 4),
                Text(
                  '${_rating.toStringAsFixed(1)} / $maxRating',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (validators.contains('required') && _rating == 0) ...[
          const SizedBox(height: 4),
          Text(
            'This field is required',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}