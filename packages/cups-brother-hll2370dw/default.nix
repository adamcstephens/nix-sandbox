{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  cups,
  dpkg,
  a2ps,
  ghostscript,
  gnugrep,
  gnused,
  coreutils,
  file,
  perl,
  which,
}:
stdenv.mkDerivation rec {
  pname = "cups-brother-hll2370dw";
  version = "4.0.0-1";

  src = fetchurl {
    # The i386 part is a lie. There are x86, x86_64 and armv7l drivers.
    # Though this builds only supports x86_64 for now.
    url = "https://download.brother.com/welcome/dlf103583/hll2370dwpdrv-${version}.i386.deb";
    hash = "sha256-bt+AbkYB9OcMLjaxHCF/TuAHdZbQC+MakDcXZcGZGWQ=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    cups
    ghostscript
    dpkg
    a2ps
  ];

  dontUnpack = true;

  installPhase = ''
    dpkg-deb -x $src $out

    substituteInPlace $out/opt/brother/Printers/HLL2370DW/lpd/lpdfilter \
      --replace /opt "$out/opt" \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$out\"; #" \
      --replace "PRINTER =~" "PRINTER = \"HLL2370DW\"; #"

    # FIXME : Allow i686 and armv7l variations to be setup instead.
    _PLAT=x86_64
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/HLL2370DW/lpd/$_PLAT/brprintconflsr3
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/HLL2370DW/lpd/$_PLAT/rawtobr3
    ln -s $out/opt/brother/Printers/HLL2370DW/lpd/$_PLAT/brprintconflsr3 $out/opt/brother/Printers/HLL2370DW/lpd/brprintconflsr3
    ln -s $out/opt/brother/Printers/HLL2370DW/lpd/$_PLAT/rawtobr3 $out/opt/brother/Printers/HLL2370DW/lpd/rawtobr3

    for f in \
      $out/opt/brother/Printers/HLL2370DW/cupswrapper/lpdwrapper \
      $out/opt/brother/Printers/HLL2370DW/cupswrapper/paperconfigml2 \
    ; do
      #substituteInPlace $f \
      wrapProgram $f \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            ghostscript
            gnugrep
            gnused
          ]
        }
    done

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/HLL2370DW/lpd/lpdfilter $out/lib/cups/filter/brother_lpdwrapper_HLL2370DW

    mkdir -p $out/share/cups/model
    ln -s $out/opt/brother/Printers/HLL2370DW/cupswrapper/brother-HLL2370DW-cups-en.ppd $out/share/cups/model/

    wrapProgram $out/opt/brother/Printers/HLL2370DW/lpd/lpdfilter \
      --prefix PATH ":" ${
        lib.makeBinPath [
          ghostscript
          a2ps
          file
          gnused
          gnugrep
          coreutils
          which
        ]
      }
  '';

  meta = with lib; {
    homepage = "http://www.brother.com/";
    description = "Brother HL-L2370DW combined print driver";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    # license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    downloadPage = "http://support.brother.com/g/b/downloadlist.aspx?c=us_ot&lang=en&prod=hll2370dw_us&os=128";
    maintainers = [ maintainers.adamcstephens ];
  };
}
