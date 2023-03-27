{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ftxui,
  libargs,
  nlohmann_json,
}:
stdenv.mkDerivation rec {
  pname = "json-tui";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "json-tui";
    rev = "v${version}";
    hash = "sha256-Rgan+Pki4kOFf4BiNmJV4mf/rgyIGgUVP1BcFCKG25w=";
  };

  prePatch = ''
    substituteInPlace CMakeLists.txt --replace 'FetchContent_Populate' '#FetchContent_Populate'
    substituteInPlace CMakeLists.txt --replace 'add_subdirectory' '#add_subdirectory'
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    ftxui
    libargs
    nlohmann_json
  ];

  meta = with lib; {
    description = "A JSON terminal UI made in C";
    homepage = "https://github.com/ArthurSonzogni/json-tui";
    changelog = "https://github.com/ArthurSonzogni/json-tui/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [];
  };
}
