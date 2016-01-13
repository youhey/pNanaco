var INPUT_FIELD = {
  nanacoId: "XCID",
  securityNumber: "SECURITY_CD",
  loginPassword: "LOGIN_PWD",
  chargePassword: "CRDT_CHEG_PWD"
};

function execAutoInput(handle) {
  var inputs = document.getElementsByTagName("input");

  for (i in inputs) {
    var input = inputs[i];

    var type = "";
    if ((input !== null) && (typeof input === "object") && ("getAttribute" in input)) {
      type = input.getAttribute("type");
    }
    switch (type) {
    case "text":
    case "hidden":
    case "password":
    case "tel":
      handle(input);
      break;
    }
  }
}

execAutoInput(function(input) {
  if (input === null) {
    return;
  }
  if (typeof input !== "object") {
    return;
  }
  if (!("value" in input)) {
    return;
  }

  var name = "";
  if ("getAttribute" in input) {
    name = input.getAttribute("name");
  }

  switch (name) {
  case INPUT_FIELD.nanacoId:
    input.value = "@nanacoId";
    break;
  case INPUT_FIELD.securityNumber:
    input.value = "@securityNumber";
    break;
  case INPUT_FIELD.loginPassword:
    input.value = "@loginPassword";
    break;
  case INPUT_FIELD.chargePassword:
    input.value = "@chargePassword";
    break;
  }
});
