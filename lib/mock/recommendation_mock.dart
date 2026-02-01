import 'dart:convert';
const String mockRecommendationJson = '''
{
  "success": true,
  "data": {
    "recommendations": [
      {
        "venueId": 101,
        "venueName": "Cafe Romance",
        "matchScore": 95,
        "aiReasoning": "Perfect for INFP personality - cozy, creative space with natural lighting.",
        "category": "Cafe",
        "address": "123 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội",
        "rating": 4.8,
        "reviewCount": 1250,
        "estimatedBudget": 150000,
        "latitude": 21.028511,
        "longitude": 105.804817,
        "distance": 2.3
      },
      {
        "venueId": 102,
        "venueName": "Sunset Rooftop",
        "matchScore": 90,
        "aiReasoning": "Great for romantic evenings with city view and soft background music.",
        "category": "Rooftop Bar",
        "address": "45 Lý Thường Kiệt, Hoàn Kiếm, Hà Nội",
        "rating": 4.6,
        "reviewCount": 860,
        "estimatedBudget": 300000,
        "latitude": 21.030211,
        "longitude": 105.807321,
        "distance": 3.1
      },
      {
        "venueId": 103,
        "venueName": "Lakeview Bistro",
        "matchScore": 85,
        "aiReasoning": "Peaceful atmosphere near the lake, ideal for calm and meaningful conversations.",
        "category": "Restaurant",
        "address": "12 Thanh Niên, Tây Hồ, Hà Nội",
        "rating": 4.5,
        "reviewCount": 540,
        "estimatedBudget": 250000,
        "latitude": 21.048321,
        "longitude": 105.837654,
        "distance": 4.5
      },
      {
        "venueId": 104,
        "venueName": "Garden Coffee",
        "matchScore": 80,
        "aiReasoning": "Green outdoor space, fresh air, suitable for relaxing daytime dates.",
        "category": "Cafe",
        "address": "88 Võ Chí Công, Tây Hồ, Hà Nội",
        "rating": 4.4,
        "reviewCount": 410,
        "estimatedBudget": 120000,
        "latitude": 21.067891,
        "longitude": 105.814235,
        "distance": 5.0
      },
      {
        "venueId": 105,
        "venueName": "Jazz Night Lounge",
        "matchScore": 78,
        "aiReasoning": "Live jazz music with intimate lighting, perfect for night-time dates.",
        "category": "Lounge",
        "address": "27 Phan Chu Trinh, Hoàn Kiếm, Hà Nội",
        "rating": 4.3,
        "reviewCount": 320,
        "estimatedBudget": 350000,
        "latitude": 21.024789,
        "longitude": 105.856432,
        "distance": 4.0
      }
    ],
    "totalResults": 10,
    "processingTimeMs": 1250,
    "aiConfidence": 0.92,
    "appliedFilters": {
      "locationType": "GPS",
      "radiusKm": 5,
      "budgetLevel": 2
    }
  }
}
''';
