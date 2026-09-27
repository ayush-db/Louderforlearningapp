class RequiredDoc {
  final String name;
  final String type;
  const RequiredDoc({required this.name, required this.type});
}

class Grant {
  final String id;
  final String funder;
  final String title;
  final List<String> tags;
  final String? specialTag;
  final String amount;
  final int amountNum;
  final String deadline;
  final String? applyUrl;
  final int? match;
  final bool isSpecialNeeds;
  final int? applicants;
  final String description;
  final List<String> eligibility;
  final List<RequiredDoc> requiredDocs;
  final int? avgCompletionMins;

  const Grant({
    required this.id,
    required this.funder,
    required this.title,
    required this.tags,
    this.specialTag,
    required this.amount,
    required this.amountNum,
    required this.deadline,
    this.applyUrl,
    this.match,
    required this.isSpecialNeeds,
    this.applicants,
    required this.description,
    required this.eligibility,
    required this.requiredDocs,
    this.avgCompletionMins,
  });
}
