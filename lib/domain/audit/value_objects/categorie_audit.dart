enum CategorieAudit {
  juridique,
  technique,
  topographique,
  fiscal,
  commercial,
  environnemental;

  String get label => switch (this) {
        CategorieAudit.juridique => 'Audit Juridique',
        CategorieAudit.technique => 'Audit Technique',
        CategorieAudit.topographique => 'Audit Topographique',
        CategorieAudit.fiscal => 'Audit Fiscal',
        CategorieAudit.commercial => 'Estimation Commerciale',
        CategorieAudit.environnemental => 'Audit Environnemental',
      };

  String get icone => switch (this) {
        CategorieAudit.juridique => '⚖️',
        CategorieAudit.technique => '🔧',
        CategorieAudit.topographique => '📐',
        CategorieAudit.fiscal => '🏛️',
        CategorieAudit.commercial => '📊',
        CategorieAudit.environnemental => '🌿',
      };
}
