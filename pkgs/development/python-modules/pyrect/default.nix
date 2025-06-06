{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pygame,
}:

buildPythonPackage rec {
  pname = "pyrect";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyRect";
    inherit version;
    hash = "sha256-9lFV9t+bkptnyv+9V8CUfFrlRJ07WA0XgHS/+0egm3g=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pygame
  ];

  pythonImportsCheck = [ "pyrect" ];

  meta = with lib; {
    description = "Simple module with a Rect class for Pygame-like rectangular areas";
    homepage = "https://github.com/asweigart/pyrect";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lucasew ];
  };
}
