import 'package:flutter/material.dart';

class CommonNetworkWidget extends StatelessWidget {
  const CommonNetworkWidget({
    super.key,
    required this.prodImage,
  });

  final String prodImage;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      prodImage,
      errorBuilder: (BuildContext context, exception, stackTrace) {
        return const Center(
          child: Icon(Icons.error, color: Colors.red),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        );
      },
      fit: BoxFit.cover,
    );
  }
}
