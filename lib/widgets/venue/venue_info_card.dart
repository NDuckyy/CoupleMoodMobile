import 'package:flutter/material.dart';

class VenueInfoCard extends StatelessWidget {
  final String title;
  final Widget? previewContent;
  final Widget? expandedContent;
  final bool expandable;
  final CrossAxisAlignment previewAlignment;
  final CrossAxisAlignment expandedAlignment;

  const VenueInfoCard({
    super.key,
    required this.title,
    this.previewContent,
    this.expandedContent,
    this.expandable = false,
    this.previewAlignment = CrossAxisAlignment.start,
    this.expandedAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: expandable
          ? Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: previewContent != null
                    ? Column(
                        crossAxisAlignment: previewAlignment,
                        children: [const SizedBox(height: 6), previewContent!],
                      )
                    : null,
                childrenPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                children: expandedContent == null
                    ? []
                    : [
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: expandedAlignment,
                            children: [expandedContent!],
                          ),
                        ),
                      ],
              ),
            )
          : SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: previewAlignment,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (previewContent != null) ...[
                      const SizedBox(height: 8),
                      previewContent!,
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
