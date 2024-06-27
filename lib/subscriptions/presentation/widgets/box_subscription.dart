import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BoxSubscription extends StatelessWidget {
  const BoxSubscription({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 130.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(50.0),
          image: const DecorationImage(
            image: CachedNetworkImageProvider(
                'https://elcomercio.pe/resizer/cQldVjFH-mDVWbJHJ2SqWAjsaI8=/580x330/smart/filters:format(jpeg):quality(75)/cloudfront-us-east-1.images.arcpublishing.com/elcomercio/3UV4OIX2A5BTRDHLKF3QLWOUHA.jpg'), // Replace with your image
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Text(
            'Pay subscription',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}


