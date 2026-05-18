{ config, pkgs, ... }: {

  # Tell sops-nix to use your local SSH host key for decryption
  sops.defaultSopsFile = ./secrets/secrets.yaml; # Optional default file path
  sops.validateSopsFiles = false; # Prevents evaluation failure if file is missing initially

  # sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  # sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # # 4. Define your certificate secret
  # sops.secrets.ca_balena = {
  #   format = "binary";
  #   sopsFile = ./secrets/ca-balena.crt.enc;
  #   path = "/etc/ssl/certs/ca-balena.pem";
  # };

}
