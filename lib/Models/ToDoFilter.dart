enum TodoFilter {
  all('Tümü'),
  today('Bugün'),
  upcoming('Yaklaşan'),
  completed('Tamamlanan');

  final String label;
  const TodoFilter(this.label); 
}