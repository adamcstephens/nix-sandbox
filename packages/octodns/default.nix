{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "octodns";
  version = "1.0.0rc0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns";
    rev = "v${version}";
    hash = "sha256-GuXx91NkbeiSgXt0ZM7WXt5ulEek6IPRQlYCPTO5LcA=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    dnspython
    fqdn
    idna
    natsort
    python-dateutil
    pyyaml
    setuptools
    six
  ];

  pythonImportsCheck = ["octodns"];

  meta = with lib; {
    description = "Tools for managing DNS across multiple providers";
    homepage = "https://github.com/octodns/octodns";
    changelog = "https://github.com/octodns/octodns/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [];
  };
}
