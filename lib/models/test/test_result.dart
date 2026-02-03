class TestResponse{
  final String status;
  final TestResult result;

  TestResponse({
    required this.status,
    required this.result,
  });

  factory TestResponse.fromJson(Map<String, dynamic> json) {
    return TestResponse(
      status: json['status']?.toString() ?? '',
      result: json['result'] is Map<String, dynamic>
          ? TestResult.fromJson(json['result'] as Map<String, dynamic>)
          : TestResult(mbtiCode: '', name: '', description: []),
    );
  }
}
class TestResult {
  final String mbtiCode;
  final String name;
  final List<String> description;
  final TestBreakdown? breakdown;

  TestResult({
    required this.mbtiCode,
    required this.name,
    required this.description,
    this.breakdown,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      mbtiCode: json['mbtiCode']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: (json['description'] is List)
          ? List<String>.from(
              (json['description'] as List).map((e) => e.toString()),
            )
          : <String>[],
      breakdown: json['breakdown'] is Map<String, dynamic>
          ? TestBreakdown.fromJson(json['breakdown'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'mbtiCode': mbtiCode,
    'name': name,
    'description': description,
    'breakdown': breakdown?.toJson(),
  };
}

/// =======================
/// Breakdown
/// =======================
class TestBreakdown {
  final TestScores scores;
  final TestPercent percent;

  TestBreakdown({required this.scores, required this.percent});

  factory TestBreakdown.fromJson(Map<String, dynamic> json) {
    return TestBreakdown(
      scores: json['scores'] is Map<String, dynamic>
          ? TestScores.fromJson(json['scores'] as Map<String, dynamic>)
          : TestScores.empty(),
      percent: json['percent'] is Map<String, dynamic>
          ? TestPercent.fromJson(json['percent'] as Map<String, dynamic>)
          : TestPercent.empty(),
    );
  }

  Map<String, dynamic> toJson() => {
    'scores': scores.toJson(),
    'percent': percent.toJson(),
  };
}

/// =======================
/// Scores
/// =======================
class TestScores {
  final int e;
  final int i;
  final int s;
  final int n;
  final int t;
  final int f;
  final int j;
  final int p;

  TestScores({
    required this.e,
    required this.i,
    required this.s,
    required this.n,
    required this.t,
    required this.f,
    required this.j,
    required this.p,
  });

  factory TestScores.fromJson(Map<String, dynamic> json) {
    int _int(dynamic v) => (v is num) ? v.toInt() : int.tryParse('$v') ?? 0;

    return TestScores(
      e: _int(json['E']),
      i: _int(json['I']),
      s: _int(json['S']),
      n: _int(json['N']),
      t: _int(json['T']),
      f: _int(json['F']),
      j: _int(json['J']),
      p: _int(json['P']),
    );
  }

  factory TestScores.empty() =>
      TestScores(e: 0, i: 0, s: 0, n: 0, t: 0, f: 0, j: 0, p: 0);

  Map<String, dynamic> toJson() => {
    'E': e,
    'I': i,
    'S': s,
    'N': n,
    'T': t,
    'F': f,
    'J': j,
    'P': p,
  };
}

/// =======================
/// Percent
/// =======================
class TestPercent {
  final double ePercent;
  final double iPercent;
  final double sPercent;
  final double nPercent;
  final double tPercent;
  final double fPercent;
  final double jPercent;
  final double pPercent;

  TestPercent({
    required this.ePercent,
    required this.iPercent,
    required this.sPercent,
    required this.nPercent,
    required this.tPercent,
    required this.fPercent,
    required this.jPercent,
    required this.pPercent,
  });

  factory TestPercent.fromJson(Map<String, dynamic> json) {
    double _dbl(dynamic v) =>
        (v is num) ? v.toDouble() : double.tryParse('$v') ?? 0.0;

    return TestPercent(
      ePercent: _dbl(json['E_percent']),
      iPercent: _dbl(json['I_percent']),
      sPercent: _dbl(json['S_percent']),
      nPercent: _dbl(json['N_percent']),
      tPercent: _dbl(json['T_percent']),
      fPercent: _dbl(json['F_percent']),
      jPercent: _dbl(json['J_percent']),
      pPercent: _dbl(json['P_percent']),
    );
  }

  factory TestPercent.empty() => TestPercent(
    ePercent: 0,
    iPercent: 0,
    sPercent: 0,
    nPercent: 0,
    tPercent: 0,
    fPercent: 0,
    jPercent: 0,
    pPercent: 0,
  );

  Map<String, dynamic> toJson() => {
    'E_percent': ePercent,
    'I_percent': iPercent,
    'S_percent': sPercent,
    'N_percent': nPercent,
    'T_percent': tPercent,
    'F_percent': fPercent,
    'J_percent': jPercent,
    'P_percent': pPercent,
  };
}
