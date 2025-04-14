{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  flit-core,

  # dependencies
  #attrs
  #cattrs
  #certifi
  #charset-normalizer
  #docstring-to-markdown
  #exceptiongroup
  #idna
  #importlib-metadata
  #iniconfig
  #jedi
  jedi-language-server,
  #lsprotocol
  #packaging
  #parso
  #pluggy
  psutil,
  #pygls
  requests,
  #tomli
  typing-extensions,
  #urllib3
  #zipp

  # tests
  pytest,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "multilspy";
  version = "0.0.15";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "multilspy";
    tag = "v${version}";
    hash = "sha256-rEE9T/o+twwWhEBD9WWxuqquk7+RVlXvGXd3jI/ix0g=";
  };

  patches = [
    ./adjust-versions.patch
  ];

  build-system = [
    flit-core
  ];

  dependencies = [
    #attrs
    #cattrs
    #certifi
    #charset-normalizer
    #docstring-to-markdown
    #exceptiongroup
    #idna
    #importlib-metadata
    #iniconfig
    #jedi
    jedi-language-server
    #lsprotocol
    #packaging
    #parso
    #pluggy
    psutil
    #pygls
    requests
    #tomli
    typing-extensions
    #urllib3
    #zipp
  ];

  nativeCheckInputs = [
    pytest
    pytest-asyncio
  ];

  preCheck = ''
    HOME="$(mktemp -d)"
  '';

  # TODO: Remove?
  #disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
  #  # https://github.com/pappasam/jedi-language-server/issues/313
  #  "test_publish_diagnostics_on_change"
  #  "test_publish_diagnostics_on_save"
  #];

  pythonImportsCheck = [ "multilspy" ];

  meta = {
    description = "LSP client library in Python";
    mainProgram = "multilspy"; # TODO: Check
    homepage = "https://github.com/microsoft/multilspy";
    changelog = "https://github.com/microsoft/multilspy/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    # TODO: Add myself.
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
