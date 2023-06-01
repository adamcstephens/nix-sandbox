{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "octodns-digitalocean";
  version = "0.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-digitalocean";
    rev = "v${version}";
    hash = "sha256-8v2EfhVOZ4jmap0Me9VsgOzDYvvlFaHd2jHaBcyc4cw=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    attrs
    certifi
    charset-normalizer
    coverage
    dnspython
    fqdn
    idna
    iniconfig
    natsort
    octodns
    packaging
    pluggy
    pprintpp
    py
    pycountry
    pycountry-convert
    pyparsing
    pytest
    pytest-cov
    pytest-mock
    python-dateutil
    pyyaml
    repoze-lru
    requests
    six
    toml
    tomli
    urllib3
  ];

  pythonImportsCheck = [ "octodns_digitalocean" ];

  meta = with lib; {
    description = "DigitalOcean DNS provider for octoDNS";
    homepage = "https://github.com/octodns/octodns-digitalocean/";
    changelog = "https://github.com/octodns/octodns-digitalocean/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ ];
    maintainers = with maintainers; [ ];
  };
}
