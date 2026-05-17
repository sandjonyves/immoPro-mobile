enum Role {
  admin,
  agent,
  client;

  String get label => switch (this) {
        Role.admin => 'Administrateur',
        Role.agent => 'Agent',
        Role.client => 'Client',
      };
}
