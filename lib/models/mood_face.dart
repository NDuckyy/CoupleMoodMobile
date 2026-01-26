class MoodFace {
  final String dominantEmotion;
  final String emotionSentence;

  MoodFace({required this.dominantEmotion, required this.emotionSentence});
  
  factory MoodFace.fromJson(Map<String, dynamic> json) {
    return MoodFace(
      dominantEmotion: json['dominantEmotion'] as String,
      emotionSentence: json['emotionSentence'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dominantEmotion': dominantEmotion,
      'emotionSentence': emotionSentence,
    };
  }
}
