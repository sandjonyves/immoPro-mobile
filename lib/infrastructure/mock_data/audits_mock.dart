import '../../domain/audit/entities/service_audit.dart';
import '../../domain/audit/value_objects/categorie_audit.dart';
import '../../domain/audit/value_objects/tarif_audit.dart';

const auditsMock = [
  ServiceAudit(
    id: 'A-001',
    titre: 'Vérification de Titre Foncier',
    description:
        'Vérification de l\'authenticité et de la validité d\'un titre foncier.',
    descriptionDetaillee:
        'Notre équipe juridique vérifie l\'authenticité du titre foncier auprès des services cadastraux, détecte les litiges potentiels, les hypothèques et les servitudes cachées. Un rapport détaillé vous est remis.',
    categorie: CategorieAudit.juridique,
    tarif: TarifAudit(minimum: 50000, maximum: 150000),
    inclusions: [
      'Vérification au cadastre',
      'Contrôle des mutations antérieures',
      'Détection des litiges pendants',
      'Rapport écrit avec conclusions',
    ],
    documents: [
      'Copie du titre foncier',
      'Pièce d\'identité du demandeur',
      'Plan de situation approximatif',
    ],
    dureeEstimee: '3 à 7 jours ouvrables',
    whatsappNumero: '237699000010',
    actif: true,
  ),
  ServiceAudit(
    id: 'A-002',
    titre: 'Bornage & Levé Topographique',
    description:
        'Délimitation précise de votre parcelle par un géomètre assermenté.',
    descriptionDetaillee:
        'Un géomètre expert se déplace sur le terrain pour effectuer le bornage officiel et le levé topographique. Les bornes sont posées et un procès-verbal est établi.',
    categorie: CategorieAudit.topographique,
    tarif: TarifAudit(minimum: 150000, maximum: 500000),
    inclusions: [
      'Déplacement du géomètre sur site',
      'Pose des bornes physiques',
      'Plan topographique géoréférencé',
      'Procès-verbal de bornage',
    ],
    documents: [
      'Titre foncier ou attestation de vente',
      'Identité propriétaire',
      'Convocation des voisins (si premier bornage)',
    ],
    dureeEstimee: '5 à 15 jours ouvrables',
    whatsappNumero: '237699000010',
    actif: true,
  ),
  ServiceAudit(
    id: 'A-003',
    titre: 'Expertise Technique du Bâtiment',
    description:
        'Évaluation de l\'état structurel d\'une construction avant achat.',
    descriptionDetaillee:
        'Un ingénieur en bâtiment inspecte la structure, les fondations, la toiture, les installations électriques et sanitaires. Idéal avant l\'achat d\'une maison ancienne.',
    categorie: CategorieAudit.technique,
    tarif: TarifAudit(minimum: 100000, maximum: 300000),
    inclusions: [
      'Inspection visuelle complète',
      'Contrôle des fondations et structures',
      'État des installations électriques',
      'Rapport photographique détaillé',
      'Recommandations de travaux',
    ],
    documents: [
      'Adresse du bien',
      'Disponibilité pour la visite (demi-journée)',
    ],
    dureeEstimee: '2 à 5 jours ouvrables',
    whatsappNumero: '237699000010',
    actif: true,
  ),
  ServiceAudit(
    id: 'A-004',
    titre: 'Estimation Commerciale du Bien',
    description:
        'Évaluation du prix juste de votre bien selon le marché actuel.',
    descriptionDetaillee:
        'Nos experts comparent votre bien avec des transactions récentes similaires dans le même quartier. Vous obtenez une fourchette de prix argumentée pour vendre ou acheter au juste prix.',
    categorie: CategorieAudit.commercial,
    tarif: TarifAudit(minimum: 30000, maximum: 80000),
    inclusions: [
      'Analyse du marché local',
      'Comparaison avec biens similaires récents',
      'Rapport d\'estimation argumenté',
      'Conseil sur le prix d\'affichage optimal',
    ],
    documents: [
      'Localisation et caractéristiques du bien',
      'Photos si disponibles',
    ],
    dureeEstimee: '2 à 4 jours ouvrables',
    whatsappNumero: '237699000010',
    actif: true,
  ),
  ServiceAudit(
    id: 'A-005',
    titre: 'Audit Fiscal & Mutation',
    description:
        'Accompagnement pour la mutation légale d\'un bien immobilier.',
    descriptionDetaillee:
        'Nous gérons toutes les formalités fiscales liées à la mutation d\'un bien : calcul des droits de mutation, déclaration aux impôts, transfert du titre foncier. Évitez les erreurs et les pénalités.',
    categorie: CategorieAudit.fiscal,
    tarif: TarifAudit(surDevis: true),
    inclusions: [
      'Calcul des droits de mutation',
      'Préparation des dossiers fiscaux',
      'Accompagnement aux guichets',
      'Suivi jusqu\'à l\'obtention du nouveau titre',
    ],
    documents: [
      'Acte de vente ou promesse',
      'Titre foncier original',
      'Pièces d\'identité vendeur et acheteur',
    ],
    dureeEstimee: 'Variable — 15 à 60 jours selon administration',
    whatsappNumero: '237699000010',
    actif: true,
  ),
  ServiceAudit(
    id: 'A-006',
    titre: 'Audit Environnemental',
    description:
        'Vérification des risques environnementaux liés à un terrain.',
    descriptionDetaillee:
        'Identification des zones à risque (inondations, glissements de terrain), vérification des servitudes environnementales et conformité avec les réglementations d\'urbanisme camerounaises.',
    categorie: CategorieAudit.environnemental,
    tarif: TarifAudit(minimum: 80000, maximum: 200000),
    inclusions: [
      'Analyse cartographique des risques',
      'Vérification zonage urbain',
      'Risques d\'inondation et d\'érosion',
      'Rapport environnemental',
    ],
    documents: [
      'Localisation GPS ou adresse précise',
      'Plan du terrain si disponible',
    ],
    dureeEstimee: '3 à 7 jours ouvrables',
    whatsappNumero: '237699000010',
    actif: true,
  ),
];
