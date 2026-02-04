const String mockRecommendationJson = '''
{
  "success": true,
  "data": {
    "recommendations": [
      {
        "venueId": 101,
        "venueName": "Cafe Romance",
        "matchScore": 95,
        "aiReasoning": "Rất phù hợp với tính cách INFP — không gian ấm cúng, mang tính sáng tạo và có ánh sáng tự nhiên.",
        "category": "Cafe",
        "address": "123 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội",
        "rating": 4.8,
        "reviewCount": 1250,
        "estimatedBudget": 150000,
        "latitude": 21.028511,
        "longitude": 105.804817,
        "distance": 2.3,
        "imageUrl": "https://noithatanthinhphat.vn/wp-content/uploads/2025/01/mau-thiet-ke-quan-cafe-dep-115.jpg"
      },
      {
        "venueId": 102,
        "venueName": "Double.N",
        "matchScore": 90,
        "aiReasoning": "Rất phù hợp cho những buổi tối lãng mạn với view thành phố và nhạc nền nhẹ nhàng.",
        "category": "Cafe",
        "address": "45 Lý Thường Kiệt, Hoàn Kiếm, Hà Nội",
        "rating": 4.6,
        "reviewCount": 860,
        "estimatedBudget": 300000,
        "latitude": 21.030211,
        "longitude": 105.807321,
        "distance": 3.1,
        "imageUrl": "https://xuongmocgocongnghiep.com/upload/news/thiet-ke-quan-cafe-dep-02.jpg"
      },
      {
        "venueId": 103,
        "venueName": "Cà phê Ngoài Trời",
        "matchScore": 85,
        "aiReasoning": "Không gian yên tĩnh gần hồ, lý tưởng cho những cuộc trò chuyện bình yên và ý nghĩa.",
        "category": "Cafe",
        "address": "12 Thanh Niên, Tây Hồ, Hà Nội",
        "rating": 4.5,
        "reviewCount": 540,
        "estimatedBudget": 250000,
        "latitude": 21.048321,
        "longitude": 105.837654,
        "distance": 4.5,
        "imageUrl": "https://zena.com.vn/wp-content/uploads/2025/10/cafe-san-vuon-trong-nha.jpg"
      },
      {
        "venueId": 104,
        "venueName": "Bếp cuốn",
        "matchScore": 80,
        "aiReasoning": "Không gian ngoài trời xanh mát, không khí trong lành, phù hợp cho những buổi hẹn ban ngày thư giãn.",
        "category": "Nhà hàng",
        "address": "88 Võ Chí Công, Tây Hồ, Hà Nội",
        "rating": 4.4,
        "reviewCount": 410,
        "estimatedBudget": 120000,
        "latitude": 21.067891,
        "longitude": 105.814235,
        "distance": 5.0,
        "imageUrl": "https://noithatmocstyle.vn/wp-content/uploads/2020/04/bep-cuon-overview-1-1.jpg"
      },
      {
        "venueId": 105,
        "venueName": "Jazz Night Lounge",
        "matchScore": 78,
        "aiReasoning": "Nhạc jazz sống với ánh sáng ấm cúng, hoàn hảo cho những buổi hẹn hò ban đêm.",
        "category": "Lounge",
        "address": "27 Phan Chu Trinh, Hoàn Kiếm, Hà Nội",
        "rating": 4.3,
        "reviewCount": 320,
        "estimatedBudget": 350000,
        "latitude": 21.024789,
        "longitude": 105.856432,
        "distance": 4.0,
        "imageUrl": "https://i.ytimg.com/vi/4eTZi9F-Jyg/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLB7hNfrHg8ah7KOLZV6BI7EnQkPmw"
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
