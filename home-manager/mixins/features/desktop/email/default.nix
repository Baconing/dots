{ inputs, config, username, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModule
  ];

  sops.secrets.emailPassword = {
    sopsFile = ../../../../../secrets/users/bacon/email.yaml;
    key = "password";
    format = "yaml";
  };
    

  accounts.email.accounts = {
    "iam@baconi.ng" = {
      primary = true;
      realName = "Bacon";
      address = "iam@baconi.ng";
      aliases = [
        "*@baconi.ng"
	"*@awesomecooldomain.pp.ua"
      ];
      userName = "iam@baconi.ng";
      passwordCommand = "cat ${config.sops.secrets.emailPassword.path}";
      thunderbird.enable = true;
      imap = {
        host = "mail.awesomecooldomain.pp.ua";
	port = 993;
	tls = {
	  enable = true;
	};
      };
      smtp = {
        host = "mail.awesomecooldomain.pp.ua";
	port = 587;
	tls = {
	  enable = true;
	};
      };
    };
  };
}

