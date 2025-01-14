final: prev: {

  perlPackages = prev.perlPackages.overrideScope (self: super: {

    CryptDES = super.CryptDES.overrideAttrs {

      patches = [
        # Fix build error with gcc14. See https://rt.cpan.org/Public/Bug/Display.html?id=133363.
        # Source: https://rt.cpan.org/Public/Ticket/Attachment/1912753/1024508/0001-_des.h-expose-perl_des_expand_key-and-perl_des_crypt.patch
        ./CryptDES-expose-perl_des_expand_key-and-perl_des_crypt.patch
      ];

    };

  });

}
