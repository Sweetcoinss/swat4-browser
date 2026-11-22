// Auto-generated skeleton from UnrealScript: Engine/AccessControl.uc
// Parent: Info

class AccessControl extends Info {

  // Variables
  IPBanned: string;  // localized string
  WrongPassword: string;  // localized string
  NeedPassword: string;  // localized string
  InvalidOptions: string;  // localized string
  AdminClass: any /* class */;  //  Class<Admin>
  AdminPassword: string;  // private globalconfig string
  GamePassword: string;  // private globalconfig string
  bDontAddDefaultAdmin: boolean;  //  bool

  constructor() {
    super();
  }

  // Methods
  SetAdminPassword(P: string): void {
      // TODO: implement
  }

  SetGamePassword(P: string): void {
      // TODO: implement
  }

  RequiresPassword(): boolean {
      // TODO: implement
  }

  Kick(S: string): boolean {
      // TODO: implement
  }

  KickBan(S: string): boolean {
      // TODO: implement
  }

  AdminLogin(P: any /* playercontroller */, Password: string): boolean {
      // TODO: implement
  }

  PreLogin(Options: string, Address: string, Error: string, FailCode: string, bSpectator: boolean): void {
      // TODO: implement
  }

  CheckIPPolicy(Address: string): boolean {
      // TODO: implement
  }

}
