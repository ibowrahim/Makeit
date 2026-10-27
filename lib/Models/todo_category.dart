enum TodoCategory {
  work('iş'),
  Personal('Kişisel'),
  Meating('Toplantı'),
  Healt('Sağlık');

  final String label;
  const TodoCategory(this.label);
}
